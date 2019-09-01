//
//  BaseItemNew.swift
//  BattleBuddy
//
//  Created by Mike on 8/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

protocol BaseItem {
    var json: [String: Any] { get }
    var type: ItemType { get }

    var id: String { get }
    var displayNameShort: String { get }
    var displayName: String { get }
    var displayDescription: String { get }
    var ergonomics: Int { get }
}

extension BaseItem {
    var id: String { get { return BaseItemUtils.getId(json: json)! } }
    var displayNameShort: String { get { return BaseItemUtils.getShortName(json: json)! } }
    var displayName: String { get { return BaseItemUtils.getName(json: json)! } }
    var displayDescription: String { get { return BaseItemUtils.getDescription(json: json)! } }
    var ergonomics: Int {
        get {
            if let ergo: NSNumber = json["ergonomics"] as? NSNumber {
                return ergo.intValue
            } else {
                return 0
            }
        }
    }
}

class BaseItemUtils {
    static func baseItemJsonValid(_ json: [String: Any]) -> Bool { return (getId(json: json) != nil && getShortName(json: json) != nil && getName(json: json) != nil && getDescription(json: json) != nil) }
    fileprivate static func getId(json: [String: Any]) -> String? { return json["_id"] as? String ?? nil }
    fileprivate static func getShortName(json: [String: Any]) -> String? { return json["shortName"] as? String ?? nil }
    fileprivate static func getName(json: [String: Any]) -> String? { return json["name"] as? String ?? nil }
    fileprivate static func getDescription(json: [String: Any]) -> String? { return json["description"] as? String ?? nil }
}

