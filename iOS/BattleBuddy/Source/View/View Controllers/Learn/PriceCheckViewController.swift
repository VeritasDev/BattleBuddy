//
//  PriceCheckViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 6/29/20.
//  Copyright © 2020 Veritas. All rights reserved.
//

import UIKit

class PriceCheckViewController: BaseTableViewController {
    let controller: PriceCheckController
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.barStyle = .black
        searchBar.delegate = self
        searchBar.placeholder = Localized("search")
        searchBar.tintColor = UIColor.Theme.primary
        if #available(iOS 13.0, *) { searchBar.searchTextField.clearButtonMode = .always }
        return searchBar
    }()

    required init?(coder: NSCoder) { fatalError() }

    init(_ controller: PriceCheckController) {
        self.controller = controller
        super.init(style: .plain)
        self.controller.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "price_check".local()
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"favorites_off"), style: .plain, target: self, action: #selector(toggleFavorites))

        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func toggleFavorites() {
        controller.toggleFavorites()

        let newImage = controller.isShowingFavorites ? UIImage(named:"favorites_on") : UIImage(named:"favorites_off")
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: newImage, style: .plain, target: self, action: #selector(toggleFavorites))
    }
}

// MARK: Table view data source
extension PriceCheckViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PriceCheckCell.ReuseIdentifier) as? PriceCheckCell ?? PriceCheckCell()
        let marketItem = controller.results[indexPath.row]
        cell.marketItem = marketItem
        cell.isFavorite = controller.isFavorite(marketItem)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let marketItem = controller.results[indexPath.row]
        controller.toggleFavorite(marketItem)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension PriceCheckViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        controller.updateSearchText(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension PriceCheckViewController {
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        searchBar.resignFirstResponder()
//        print("AAAA")
//    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("BBBB")
        searchBar.resignFirstResponder()
    }
}

extension PriceCheckViewController: PriceCheckControllerDelegate {
    func resultsDidChange() {
        tableView.reloadData()
    }

    func enableSearchBar(_ enabled: Bool) {
        searchBar.isUserInteractionEnabled = enabled
        searchBar.text = nil
        searchBar.alpha = enabled ? 1.0 : 0.2
    }
}
