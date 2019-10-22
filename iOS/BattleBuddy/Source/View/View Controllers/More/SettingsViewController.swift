//
//  SettingsViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 9/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

// TODO:
// - Push notifications
// - Nickname
// - Banner ads
// - Interstitials
class SettingsViewController: BaseTableViewController {
    let accountManager = dm().accountManager()
    let adManager = dm().adManager()
    let prefsManager = dm().prefsManager()
    let localeManager = dm().localeManager()
    var sections: [GroupedTableViewSection] = []

    lazy var nicknameCell: BaseTextfieldCell = {
        let attr: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(white: 0.6, alpha: 1.0),
            NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 18.0)
        ]
        let cell = BaseTextfieldCell()
        cell.textField.attributedPlaceholder = NSAttributedString(string: "nickname_placeholder".local(), attributes: attr)
        cell.height = 70.0
        cell.textField.autocorrectionType = .no
        cell.textField.font = .systemFont(ofSize: 20, weight: .medium)
        cell.textField.delegate = self
        cell.textField.clearButtonMode = UITextField.ViewMode.whileEditing
        return cell
    }()
    let languageCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "language".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 18.0)
        cell.accessoryType = .disclosureIndicator
        cell.height = 70.0
        return cell
    }()
    lazy var enableBannerAdsCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "enable_banner_ads".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.accessoryView = {
            let toggle = UISwitch()
            toggle.setOn(adManager.bannerAdsEnabled(), animated: false)
            toggle.addTarget(self, action: #selector(toggleBannerAds(sender:)), for: .valueChanged)
            return toggle
        }()
        cell.selectionStyle = .none
        cell.height = 70.0
        return cell
    }()


    @objc func toggleBannerAds(sender: UISwitch) {
        let adsEnabled = sender.isOn
        adManager.updateBannerAdsSetting(adsEnabled)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "settings".local()

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50.0))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNickname)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNickname))
        ]
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = UIColor.Theme.primary
        nicknameCell.textField.inputAccessoryView = toolbar
    }

    override func viewWillAppear(_ animated: Bool) {
        updateCells()
    }

    func updateCells() {
        sections = []

        if let metaData = accountManager.currentUserMetadata() {
            nicknameCell.textField.text = metaData.nickname
            sections.append(GroupedTableViewSection(headerTitle: "profile".local(), cells: [nicknameCell]))
        }

        languageCell.detailTextLabel?.text = localeManager.currentLanguageDisplayName()
        sections.append(GroupedTableViewSection(headerTitle: "app_settings".local(), cells: [languageCell]))
        tableView.reloadData()
    }

    @objc func cancelNickname() {
        nicknameCell.textField.resignFirstResponder()
    }

    @objc func saveNickname() {
        let name = nicknameCell.textField.text ?? ""

        showLoading()

        accountManager.updateAccountProperties([.nickname: name]) { success in
            self.hideLoading()

            if !success { self.showOkAlert(message: "settings_save_error".local()) }

            self.updateCells()
            self.nicknameCell.textField.resignFirstResponder()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cells[indexPath.row].height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cells[indexPath.row]
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)
        switch cell {
        case languageCell: navigationController?.pushViewController(LanguageSelectionViewController(), animated: true)
        default: break;
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let previousText = textField.text as NSString?
        guard let resultingText = previousText?.replacingCharacters(in: range, with: string) else { return true }
        return resultingText.count <= 18
    }
}
