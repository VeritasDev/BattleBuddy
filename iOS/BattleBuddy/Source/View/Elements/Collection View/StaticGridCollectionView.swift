//
//  StaticGridCollectionView.swift
//  BattleBuddy
//
//  Created by Mike on 6/28/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class StaticGridCollectionView: BaseCollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let itemCount: Int
    let defaultColumnCount: Int
    let compactColumnCount: Int
    let cellId = "StaticGridCollectionViewCell"

    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    init(numberOfItems: Int, defaultColumns: Int, compactColumns: Int) {
        itemCount = numberOfItems
        defaultColumnCount = defaultColumns
        compactColumnCount = compactColumns
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

        register(StaticGridCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        dataSource = self
        delegate = self
        backgroundColor = .white
        isScrollEnabled = false
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Nikita says 'subclasses must override this!'")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let columnCount = collectionView.traitCollection.horizontalSizeClass == .compact ? compactColumnCount : defaultColumnCount
        let rowCount: Int = Int(ceil(Float(itemCount) / Float(columnCount)))
        return CGSize.init(width: width / CGFloat(columnCount), height: height / CGFloat(rowCount))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
