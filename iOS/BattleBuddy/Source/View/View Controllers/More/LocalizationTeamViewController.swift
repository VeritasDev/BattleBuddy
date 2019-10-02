//
//  LocalizationTeamViewController.swift
//  BattleBuddy
//
//  Created by Mike on 8/28/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

struct LanguageTeam {
    let languageCodes: [String]
    let members: [String]
}

class LocalizationTeamViewController: BaseTableViewController {
    lazy var teams: [LanguageTeam] = {
        return [
            LanguageTeam(languageCodes: ["nb"], members: ["Vegard Kjølås"]),
            LanguageTeam(languageCodes: ["nl"], members: ["Robinblitz"]),
            LanguageTeam(languageCodes: ["ru"], members: ["JackWithMeat", "Danila \"Danilablond\"", "Anatoly \"Nagodre\" Kotov", "Alexey Byron"]),
            LanguageTeam(languageCodes: ["it"], members: ["Adriano Crippa"]),
            LanguageTeam(languageCodes: ["sv"], members: ["Octane", "Scout Commando Prox"]),
            LanguageTeam(languageCodes: ["es_es"], members: ["Hugo Gómez"]),
            LanguageTeam(languageCodes: ["sr", "hr"], members: ["ANDstriker"]),
            LanguageTeam(languageCodes: ["ro"], members: ["FreeSpy443", "Glupin_Blupin"]),
            LanguageTeam(languageCodes: ["lt"], members: ["Rokas \"Alacrino\" Juodelis"]),
            LanguageTeam(languageCodes: ["pl"], members: ["hot gamer girl, Emin3X"]),
            LanguageTeam(languageCodes: ["de"], members: ["Nico \"Desteny\"", "PaaX", "Keks / McKnopp"]),
            LanguageTeam(languageCodes: ["fr"], members: ["Jean-Michel Fiché S"]),
            LanguageTeam(languageCodes: ["es_419"], members: ["Rusty"]),
            LanguageTeam(languageCodes: ["pt_pt"], members: ["Joel Fernandes \"jel\""]),
            LanguageTeam(languageCodes: ["pt_br"], members: ["Spuritika", "Sir_Tai"]),
            LanguageTeam(languageCodes: ["hu"], members: ["Kevin Patkósi"]),
            LanguageTeam(languageCodes: ["cs"], members: ["Frren"]),
            LanguageTeam(languageCodes: ["zh-hk"], members: ["jasonlin12356789", "Allen Chang"]),
            LanguageTeam(languageCodes: ["sl"], members: ["CrazyHKS"]),
            LanguageTeam(languageCodes: ["ko"], members: ["JT"]),
            LanguageTeam(languageCodes: ["ja"], members: ["Ruin"])
        ]
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "attributions_translations".local()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let codes = teams[section].languageCodes
        return codes.compactMap { Locale.autoupdatingCurrent.localizedString(forLanguageCode: $0) }.joined(separator: ", ")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return teams.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams[section].members.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as? BaseTableViewCell ?? BaseTableViewCell(style: .default, reuseIdentifier: "NameCell")
        cell.textLabel?.text = teams[indexPath.section].members[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
