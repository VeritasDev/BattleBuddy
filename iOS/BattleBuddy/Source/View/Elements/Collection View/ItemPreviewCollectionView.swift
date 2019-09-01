//
//  ItemPreviewCollectionView.swift
//  BattleBuddy
//
//  Created by Mike on 7/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol ItemPreviewDelegate {
    func didSelectItem(item: Displayable)
}

class ItemPreviewCollectionView: BaseCollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let defaultPadding: CGFloat = 10.0
    let previewCellId: String = "PreviewCell"
    var config: ItemPreviewConfiguration {
        didSet {
            reloadData()
        }
    }
    var itemPreviewDelegate: ItemPreviewDelegate?

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(config: ItemPreviewConfiguration) {
        self.config = config

        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        delegate = self
        dataSource = self

        register(ItemPreviewCell.self, forCellWithReuseIdentifier: previewCellId)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return config.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! ItemPreviewCell
        cell.item = config.items[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemPreviewDelegate?.didSelectItem(item: config.items[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth: CGFloat
        var cellHeight: CGFloat
        let collectionViewWidth = collectionView.frame.width
        let collectionViewHeight = collectionView.frame.height
        let rowsOrColumns = CGFloat(collectionView.isCompactWidth() ? config.staticDimensionCompact : config.staticDimensionRegular)
        let totalPadding = (defaultPadding * (rowsOrColumns + 1))

        switch config.scrollDirection {
        case .horizontal:
            let usableHeight = floor(collectionViewHeight - totalPadding)
            cellHeight = floor(usableHeight / rowsOrColumns)
            cellWidth = floor(cellHeight * CGFloat(config.aspectRatioMultipler))
        case .vertical:
            let usableWidth = floor(collectionViewWidth - totalPadding)
            cellWidth = floor(usableWidth / rowsOrColumns)
            cellHeight = floor(cellWidth / CGFloat(config.aspectRatioMultipler))
        default:
            fatalError()
        }

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: defaultPadding, bottom: 0, right: defaultPadding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return defaultPadding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
