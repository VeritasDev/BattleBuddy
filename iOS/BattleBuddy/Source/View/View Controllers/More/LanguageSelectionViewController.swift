//
//  LanguageSelectionViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 9/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: BaseTableViewController {
    let prefsManager = dm().prefsManager()
    let supportedLanguages = dm().localeManager().supportedLanguages()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "language".local()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : supportedLanguages.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "langCell") ?? BaseTableViewCell(style: .default, reuseIdentifier: "langCell")

        let currentLanguageSetting = prefsManager.valueForStringPref(.languageOverride)
        let applicableLanguageCode: String?
        if indexPath.section == 0 {
            cell.textLabel?.text = "language_system_default".local()
            applicableLanguageCode = nil
        } else {
            let language = supportedLanguages[indexPath.row]
            cell.textLabel?.text = language.displayName
            applicableLanguageCode = language.code
        }

        cell.accessoryType = currentLanguageSetting == applicableLanguageCode ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selection: String? = indexPath.section == 1 ? supportedLanguages[indexPath.row].code : nil
        prefsManager.update(Preference.languageOverride, value: selection)

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.reloadRootViewController()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
