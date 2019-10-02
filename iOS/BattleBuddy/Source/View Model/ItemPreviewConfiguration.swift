//
//  ItemPreviewConfiguration.swift
//  BattleBuddy
//
//  Created by Mike on 7/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

struct ItemSection {
    let title: String
    let items: [Displayable]
}

struct ItemListConfig {
    let type: ItemType
    let title: String
    let cellWidthMultiplier: CGFloat
    var sections: [ItemSection] = []

    init(_ type: ItemType) {
        self.type = type
        self.title = type.localizedTitle()

        switch type {
        case .firearm: cellWidthMultiplier = 1.6
        case .ammo, .armor, .medical, .helmet, .modification: cellWidthMultiplier = 1.3
        default: fatalError()
        }
    }
}

protocol ItemPreviewConfiguration {
    var title: String { get }
    var items: [Displayable] { get set }
    var scrollDirection: UICollectionView.ScrollDirection { get }
    var staticDimensionCompact: Int { get }
    var staticDimensionRegular: Int { get }
    var aspectRatioMultipler: Float { get }
}

struct SearchResultsPreviewConfiguration: ItemPreviewConfiguration {
    let title: String = Localized("search")
    var items: [Displayable] = []
    let scrollDirection: UICollectionView.ScrollDirection = .vertical
    let staticDimensionCompact: Int = 1
    let staticDimensionRegular: Int = 3
    let aspectRatioMultipler: Float = 1.77
}

struct FirearmPreviewConfiguration: ItemPreviewConfiguration {
    let dbManager = DependencyManagerImpl.shared.databaseManager()
    let title: String = Localized("firearms")
    var items: [Displayable]
    let scrollDirection: UICollectionView.ScrollDirection = .vertical
    let staticDimensionCompact: Int = 2
    let staticDimensionRegular: Int = 3
    let aspectRatioMultipler: Float = 1.5
}

struct ThrowablesPreviewConfiguration: ItemPreviewConfiguration {
    let dbManager = DependencyManagerImpl.shared.databaseManager()
    let title: String = Localized("throwables")
    var items: [Displayable]
    let scrollDirection: UICollectionView.ScrollDirection = .vertical
    let staticDimensionCompact: Int = 2
    let staticDimensionRegular: Int = 3
    let aspectRatioMultipler: Float = 1.5
}

struct MeleePreviewConfiguration: ItemPreviewConfiguration {
    let dbManager = DependencyManagerImpl.shared.databaseManager()
    let title: String = Localized("main_menu_melee")
    var items: [Displayable]
    let scrollDirection: UICollectionView.ScrollDirection = .vertical
    let staticDimensionCompact: Int = 2
    let staticDimensionRegular: Int = 3
    let aspectRatioMultipler: Float = 1.5
}

struct AmmoPreviewConfiguration: ItemPreviewConfiguration {
    let dbManager = DependencyManagerImpl.shared.databaseManager()
    let title: String = Localized("ammunition")
    var items: [Displayable]
    let scrollDirection: UICollectionView.ScrollDirection = .vertical
    let staticDimensionCompact: Int = 2
    let staticDimensionRegular: Int = 4
    let aspectRatioMultipler: Float = 1.2
}

struct ArmorPreviewConfiguration: ItemPreviewConfiguration {
    let dbManager = DependencyManagerImpl.shared.databaseManager()
    let title: String = Localized("armor")
    var items: [Displayable]
    let scrollDirection: UICollectionView.ScrollDirection = .vertical
    let staticDimensionCompact: Int = 2
    let staticDimensionRegular: Int = 4
    let aspectRatioMultipler: Float = 1.3
}
