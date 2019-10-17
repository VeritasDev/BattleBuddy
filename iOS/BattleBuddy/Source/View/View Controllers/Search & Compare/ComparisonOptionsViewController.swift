//
//  ComparisonOptionsViewController.swift
//  BattleBuddy
//
//  Created by Mike on 7/16/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class ComparisonOptionsViewController: BaseTableViewController {
    var comparison: ItemComparison
    let cellReuseId: String = "OptionCell"
    var hasShownDefaults: Bool = false

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ comparison: ItemComparison) {
        self.comparison = comparison
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "compare_with".local()

        navigationItem.rightBarButtonItem = .init(title: "continue".local(), style: .plain, target: self, action: #selector(continueWithComparison))

        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !hasShownDefaults {
            hasShownDefaults = true
            continueWithComparison()
        }
    }

    @objc func continueWithComparison() {
        let compareVC = ItemCompareViewController(comparison)
        navigationController?.pushViewController(compareVC, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = 1
        if !comparison.recommendedOptions.isEmpty { sectionCount += 1 }
        if !comparison.secondaryRecommendedOptions.isEmpty { sectionCount += 1 }
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if comparison.recommendedOptions.count == 0 {
            return nil
        } else {
            if section == 0 {
                return comparison.recommendedOptionsTitle ?? "recommended".local()
            } else if section == 1 {
                if comparison.secondaryRecommendedOptions.isEmpty {
                    return !comparison.possibleOptions.isEmpty ? "all".local() : nil
                } else {
                    return comparison.secondaryRecommendedOptionsTitle ?? "similar".local()
                }
            } else if !comparison.possibleOptions.isEmpty {
                return "all".local()
            } else {
                return nil
            }
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            header.textLabel?.textColor = .white
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comparison.recommendedOptions.count == 0 {
            return comparison.possibleOptions.count
        } else {
            if section == 0 {
                return comparison.recommendedOptions.count
            } else if section == 1 {
                return comparison.secondaryRecommendedOptions.isEmpty ? comparison.possibleOptions.count : comparison.secondaryRecommendedOptions.count
            } else {
                return comparison.possibleOptions.count
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selection: Comparable = comparableAtIndexPath(indexPath)

        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        cell.textLabel?.text = selection.title
        cell.textLabel?.numberOfLines = 0
        cell.tintColor = UIColor.Theme.primary

        var selected = false
        for currentSelection in comparison.itemsBeingCompared {
            if currentSelection.identifier == selection.identifier {
                selected = true
            }
        }

        cell.accessoryType = selected ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selection: Comparable = comparableAtIndexPath(indexPath)

        var alreadySelected = false
        for currentSelection in comparison.itemsBeingCompared {
            if currentSelection.identifier == selection.identifier {
                alreadySelected = true
            }
        }

        var itemsBeingCompared = comparison.itemsBeingCompared
        if alreadySelected {
            itemsBeingCompared.removeAll{ $0.identifier == selection.identifier }
        } else {
            itemsBeingCompared.append(selection)
        }

        comparison.itemsBeingCompared = itemsBeingCompared

        tableView.reloadRows(at: [indexPath], with: .fade)
    }

    func comparableAtIndexPath(_ indexPath: IndexPath) -> Comparable {
        if comparison.recommendedOptions.count == 0 {
            return comparison.possibleOptions[indexPath.row]
        } else {
            if indexPath.section == 0 {
                return comparison.recommendedOptions[indexPath.row]
            } else if indexPath.section == 1 {
                return comparison.secondaryRecommendedOptions.isEmpty ? comparison.possibleOptions[indexPath.row] : comparison.secondaryRecommendedOptions[indexPath.row]
            } else {
                return comparison.possibleOptions[indexPath.row]
            }
        }
    }
}

