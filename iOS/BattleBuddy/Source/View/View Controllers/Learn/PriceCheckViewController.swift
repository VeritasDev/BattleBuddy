//
//  PriceCheckViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 6/29/20.
//  Copyright © 2020 Veritas. All rights reserved.
//

import UIKit

enum PriceCheckCategory: Localizable {
    case all
    case favorites
    case top
    case trending

    func local(short: Bool = false) -> String {
        switch self {
        case .all: return "price_check_sort_all".local()
        case .favorites: return "price_check_sort_favorites".local()
        case .top: return "price_check_sort_top".local()
        case .trending: return "price_check_sort_trending".local()
        }
    }
}

class PriceCheckViewController: BaseTableViewController {
    let prefs = DependencyManagerImpl.shared.prefsManager()
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.barStyle = .black
        searchBar.delegate = self
        searchBar.placeholder = Localized("search")
        searchBar.tintColor = UIColor.Theme.primary
        if #available(iOS 13.0, *) { searchBar.searchTextField.clearButtonMode = .always }
        return searchBar
    }()
    let allMarketItems: [MarketItem]
    var favorites: [MarketItem] = []
    var searchResults: [MarketItem] = [] { didSet { tableView.reloadData() } }
    let categoryPicker: UISegmentedControl = {
        let segmentedControl =  UISegmentedControl(items: [PriceCheckCategory.all.local(), PriceCheckCategory.favorites.local(), PriceCheckCategory.top.local()])
        segmentedControl.backgroundColor = UIColor.Theme.background
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)

        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor.Theme.primary
        } else {
            segmentedControl.tintColor = UIColor.Theme.primary
        }
        return segmentedControl
    }()
    lazy var headerStackView: BaseStackView = {
        let stackView = BaseStackView(axis: .vertical)
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(categoryPicker)
        return stackView
    }()

    required init?(coder: NSCoder) { fatalError() }

    init(_ marketItems: [MarketItem]) {
        allMarketItems = marketItems
        super.init(style: .plain)

        updateFavorites()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "price_check".local()
        navigationItem.titleView = searchBar
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateResults(with: nil)
    }

    private func updateResults(with searchText: String?) {
        if let search = searchText {
            searchResults = allMarketItems.filter { $0.matchesSearch(search) }
        } else {
            searchResults = []
        }
    }

    private func updateFavorites() {
    }
}

// MARK: Table view data source
extension PriceCheckViewController {
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
////        if !favorites.isEmpty && section == 0 { return "price_check_sort_favorites".local() }
////        else { return searchResults == 0 ? "price_check_sort_" : searchResults.count }
//    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PriceCheckCell.ReuseIdentifier) as? PriceCheckCell ?? PriceCheckCell()

        cell.marketItem = searchResults[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let marketItem = searchResults[indexPath.row]

    }
}

extension PriceCheckViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateResults(with: searchText)
    }
}
