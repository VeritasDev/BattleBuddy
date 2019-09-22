//
//  MainMenuCollectionView.swift
//  BattleBuddy
//
//  Created by Mike on 6/29/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import JGProgressHUD

class MainMenuCollectionViewController: BaseCollectionViewController {
    let cellId = "MainMenuCell"
    let menuItems: [MainMenuItem]
    let adManager = dm().adManager()

    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    required init(items: [MainMenuItem]) {
        menuItems = items

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15.0
        super.init(collectionViewLayout: layout)

        collectionView.register(MainMenuCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 10)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        adManager.addBannerToView(view)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        collectionViewLayout.invalidateLayout()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MainMenuCell
        cell.menuItem = menuItems[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = menuItems[indexPath.item]

        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)

        item.loadDestinationViewController { destinationVC in
            hud.dismiss(animated: false)
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let menuItem = menuItems[indexPath.item]
        let totalAvailableWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        let collectionViewHeight = collectionView.frame.height
        let isCompact = collectionView.traitCollection.horizontalSizeClass == .compact

        if isCompact {
            let width: CGFloat = floor(totalAvailableWidth)
            let height: CGFloat

            switch menuItem.compactSize {
            case .small:
                height = floor(collectionViewHeight * 0.2)
            case .medium:
                height = floor(collectionViewHeight * 0.3)
            case .large:
                height = floor(collectionViewHeight * 0.45)
            }
            return CGSize.init(width: width, height: height)
        } else {
            switch menuItem.regularSize {
            case .small, .medium:
                fatalError()
            case .large:
                let width = totalAvailableWidth / 2.0
                return CGSize.init(width: width, height: width * 0.56)
            }
        }
    }
}
