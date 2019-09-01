//
//  PreviewMenuCollectionView.swift
//  BattleBuddy
//
//  Created by Mike on 7/7/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol PreviewMenuSelectionDelegate {
    func didSelectDisplayableItem(_ displayable: Displayable)
}

class PreviewMenuCollectionView: BaseCollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let selectionDelegate: PreviewMenuSelectionDelegate
    let previewMenuCellId = "PreviewMenuCell"
    let cellWidthMutlipler: CGFloat
    let items: [Displayable]

    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    required init(selectionDelegate: PreviewMenuSelectionDelegate, items: [Displayable], cellWidthMutlipler: CGFloat) {
        self.selectionDelegate = selectionDelegate
        self.cellWidthMutlipler = cellWidthMutlipler
        self.items = items

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: CGRect.zero, collectionViewLayout: layout)

        register(PreviewMenuCell.self, forCellWithReuseIdentifier: previewMenuCellId)
        dataSource = self
        delegate = self
        backgroundColor = UIColor(white: 0.07, alpha: 1.0)
        showsHorizontalScrollIndicator = false
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewMenuCellId, for: indexPath) as! PreviewMenuCell
        cell.displayableItem = items[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectionDelegate.didSelectDisplayableItem(items[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height * 0.9
        let width = height * cellWidthMutlipler
        return CGSize.init(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
