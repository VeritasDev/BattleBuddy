//
//  ItemsMenuViewController.swift
//  BattleBuddy
//
//  Created by Mike on 6/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class ItemsMenuViewController: MainMenuCollectionViewController {
    let searchResultsVC = BaseItemPreviewViewController(delegate: nil, config: SearchResultsPreviewConfiguration())
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsVC)
        searchController.searchBar.delegate = searchResultsVC
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Localized("search")
        searchController.searchBar.tintColor = UIColor.Theme.primary
        return searchController
    }()
    required init(items: [MainMenuItem]) { fatalError("NIMP") }
    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    required init() {
        super.init(items: [
            MainMenuItem(type: .firearms, compactSize: .medium, regularSize: .large),
            MainMenuItem(type: .ammunition, compactSize: .medium, regularSize: .large),

            MainMenuItem(type: .armor, compactSize: .medium, regularSize: .large),
            MainMenuItem(type: .helmets, compactSize: .medium, regularSize: .large),
            MainMenuItem(type: .visors, compactSize: .medium, regularSize: .large),
            MainMenuItem(type: .medical, compactSize: .medium, regularSize: .large),

            MainMenuItem(type: .melee, compactSize: .medium, regularSize: .large),
            MainMenuItem(type: .throwables, compactSize: .medium, regularSize: .large),
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearch))
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: Search

    @objc func showSearch() {
        searchController.searchBar.becomeFirstResponder()
    }
}
