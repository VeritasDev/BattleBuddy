//
//  SortableTableViewController.swift
//  BattleBuddy
//
//  Created by Mike on 8/4/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol SortableItemSelectionDelegate {
    func itemSelected(_ selection: Sortable)
    func selectionCancelled()
}

class SortableTableViewController: BaseTableViewController, SortableHeaderViewDelegate {
    let selectionDelegate: SortableItemSelectionDelegate
    let config: SortConfiguration
    var currentSelection: Sortable?
    lazy var header: SortableHeaderView = { SortableHeaderView(delegate: self, params: config.params, initialSort: config.defaultSortParam) }()
    var presentedModally = true
    var searchResults: [Sortable]? { didSet { tableView.reloadData() } }
    var items: [Sortable] { get { return searchResults ?? config.items } }
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.barStyle = .black
        searchBar.delegate = self
        searchBar.placeholder = Localized("search")
        searchBar.tintColor = UIColor.Theme.primary

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50.0))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSearch)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = UIColor.Theme.primary
        searchBar.inputAccessoryView = toolbar

        return searchBar
    }()

    required init?(coder: NSCoder) { fatalError() }

    init(selectionDelegate: SortableItemSelectionDelegate, config: SortConfiguration, currentSelection: Sortable?) {
        self.selectionDelegate = selectionDelegate
        self.config = config
        self.currentSelection = currentSelection

        super.init(style: .plain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = config.sortTitle

        if presentedModally {
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        }

        navigationItem.titleView = searchBar

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.tableFooterView = UIView()
    }

    @objc func cancelSearch() {
        searchBar.text = nil
        searchResults = nil
        searchBar.resignFirstResponder()
    }

    @objc func handleCancel() {
        selectionDelegate.selectionCancelled()
    }

    func toggleSort(param: SortableParam) {
        config.toggleStateForParam(param)

        if !items.isEmpty {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK:- Search
extension SortableTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = searchText.isEmpty ? nil : config.items.filter { $0.matchesSearch(searchText) }
    }
}

// MARK:- Table view data source
extension SortableTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? config.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortableTableViewCell.reuseId) ?? SortableTableViewCell(config: config)
        guard let sortableCell = cell as? SortableTableViewCell else { fatalError() }
        let item = items[indexPath.row]
        sortableCell.item = item
        sortableCell.isSelectedOption = (item.sortId == currentSelection?.sortId)
        return sortableCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = items[indexPath.row]
        selectionDelegate.itemSelected(item)
    }
}
