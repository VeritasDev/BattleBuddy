//
//  BaseItemPreviewViewController.swift
//  BattleBuddy
//
//  Created by Mike on 7/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseItemPreviewViewController: BaseViewController, ItemPreviewDelegate, UISearchBarDelegate {
    let collectionView: ItemPreviewCollectionView
    let dbManager = DependencyManager.shared.databaseManager
    let config: ItemPreviewConfiguration

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(delegate: ItemPreviewDelegate?, config: ItemPreviewConfiguration) {
        collectionView = ItemPreviewCollectionView(config: config)
        self.config = config

        super.init()

        title = config.title

        collectionView.itemPreviewDelegate = delegate ?? self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.pinToContainer()
    }

    func didSelectItem(item: Displayable) {
        let vc = ItemDetailsConfigurationFactory.configuredItemDetailsViewController(displayable: item)

        if let nc = navigationController {
            nc.pushViewController(vc, animated: true)
        } else if let presentingNC = presentingViewController?.navigationController {
            presentingNC.pushViewController(vc, animated: true)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }

        showLoading()

        DependencyManager.shared.databaseManager.getAllItemsWithSearchQuery(searchText) { results in
            self.hideLoading()

            var newConfig = self.collectionView.config
            newConfig.items = results as! [Displayable]
            self.collectionView.config = newConfig
        }
    }
}
