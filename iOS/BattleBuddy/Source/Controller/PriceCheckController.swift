//
//  PriceCheckController.swift
//  BattleBuddy
//
//  Created by Veritas on 7/3/20.
//  Copyright © 2020 Veritas. All rights reserved.
//

import UIKit

protocol PriceCheckControllerDelegate {
    func resultsDidChange()
    func enableSearchBar(_ enabled: Bool)
}

class PriceCheckController: NSObject {
    var delegate: PriceCheckControllerDelegate?
    var results: [MarketItem] = []
    private let allItems: [MarketItem]
    private let prefs = DependencyManagerImpl.shared.prefsManager()
    lazy var favorites: [String] = prefs.valueForArrayPref(.favoriteMarketItems) as? [String] ?? []
    private var searchText: String?
    var isShowingFavorites: Bool = false

    init(_ allItems: [MarketItem]) {
        self.allItems = allItems
        results = allItems
    }

    public func updateSearchText(_ text: String?) {
        if let newSearchText = text, // non-nil
            !newSearchText.isEmpty, // non-empty
            let currentSearchText = searchText, // non-nil
            newSearchText.count > currentSearchText.count, // we're adding characters
            currentSearchText.containsIgnoringCase(newSearchText)  { // adding characters to prior search
            results = results.filter({ (item) -> Bool in matchesSearch(item, search: newSearchText) })
        } else {
            results = allItems
        }

        searchText = text
        updateResults()
    }

    public func toggleFavorites() {
        isShowingFavorites = !isShowingFavorites

        if isShowingFavorites {
            delegate?.enableSearchBar(false)
            results = allItems.filter({ item -> Bool in favorites.contains(item.itemId) })
        } else {
            delegate?.enableSearchBar(true)
            results = allItems
        }

        delegate?.resultsDidChange()
    }

    public func isFavorite(_ marketItem: MarketItem) -> Bool {
        return favorites.contains(marketItem.itemId)
    }

    public func toggleFavorite(_ marketItem: MarketItem) {
        let itemId = marketItem.itemId
        if isFavorite(marketItem) {
            favorites.removeAll { id -> Bool in id == itemId }
        } else {
            favorites.append(itemId)
        }

        prefs.update(.favoriteMarketItems, value: favorites)
    }

    private func updateResults() {

        if let search = searchText, !search.isEmpty {
            results = results.filter({ (item) -> Bool in matchesSearch(item, search: search) })
        }

        results = results.sorted(by: { (a, b) -> Bool in a.pricePerSlot > b.pricePerSlot })
        delegate?.resultsDidChange()
    }

    private func matchesSearch(_ marketItem: MarketItem, search: String) -> Bool {
        return marketItem.name.containsIgnoringCase(search) || marketItem.shortName.containsIgnoringCase(search)
    }
}
