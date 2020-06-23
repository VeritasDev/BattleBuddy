//
//  Twitch.swift
//  BattleBuddy
//
//  Created by Mike on 8/8/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

enum TwitchChannel: String, Linkable, CaseIterable {
    case veritas = "veritas"
    case ghostfreak = "ghostfreak66"
    case slushpuppy = "slushpuppy"
    case pestily = "pestily"
    case anton = "anton"
    case sigma = "sigma"

    func name() -> String {
        switch self {
        case .veritas: return "Veritas"
        case .ghostfreak: return "GhostFreak66"
        case .slushpuppy: return "Slushpuppy"
        case .pestily: return "Pestily"
        case .anton: return "Anton"
        case .sigma: return "Sigma"
        }
    }

    func userId() -> String {
        switch self {
        case .veritas: return "87307183"
        case .ghostfreak: return "53821185"
        case .slushpuppy: return "145233973"
        case .pestily: return "106013742"
        case .anton: return "63880003"
        case .sigma: return "181938671"//38849267328" //or 181938671
        }
    }

    func iconImage() -> UIImage {
        switch self {
        case .veritas: return UIImage(named: "veritas")!
        case .ghostfreak: return UIImage(named: "ghostfreak")!
        case .slushpuppy: return UIImage(named: "slushpuppy")!
        case .pestily: return UIImage(named: "pestily")!
        case .anton: return UIImage(named: "anton")!
        case .sigma: return UIImage(named: "sigma")!
        }
    }

    func local(short: Bool) -> String { return name() }
    func description() -> String? { return nil }
    func regularUrl() -> URL? { return URL(string: "http://www.twitch.tv/\(rawValue)")! }
    func deeplinkUrl() -> URL? { return nil }

}

struct TwitchChannelInfo {
    let twitchId: String
    let channelName: String
    let isLive: Bool
}

struct TwitchSummary {
    var channelInfo: [TwitchChannel: TwitchChannelInfo] = [:]
}
