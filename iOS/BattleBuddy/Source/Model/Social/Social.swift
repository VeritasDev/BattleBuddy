//
//  Social.swift
//  BattleBuddy
//
//  Created by Mike on 8/8/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol Linkable: Localizable {
    func iconImage() -> UIImage
    func local(short: Bool) -> String
    func description() -> String?
    func regularUrl() -> URL?
    func deeplinkUrl() -> URL?
}

enum VeritasSocial: String, Linkable {
    case twitch = "twitch"
    case twitter = "twitter"
    case youtube = "youtube"
    case spotify = "spotify"
    case website = "website"
    case discord = "discord"
    case instagram = "instagram"
    case soundcloud = "soundcloud"
    case github = "github"

    func iconImage() -> UIImage { return UIImage(named: rawValue)! }
    func local(short: Bool = false) -> String { return rawValue.local() }
    func description() -> String? { return "\(rawValue)_description".local() }
    func regularUrl() -> URL? {
        switch self {
        case .twitch: return URL(string: "https://www.twitch.tv/veritas")
        case .twitter: return URL(string: "https://www.twitter.com/veriitasgames")
        case .youtube: return URL(string: "https://www.youtube.com/c/veriitasgames")
        case .spotify: return URL(string: "https://open.spotify.com/artist/2S6iwClVoSNnpOcCzyMeUj")
        case .website: return URL(string: "https://www.veritas.wtf")
        case .discord: return URL(string: "https://discord.gg/GjnHhxS")
        case .instagram: return URL(string: "https://www.instagram.com/veritaswtf/")
        case .soundcloud: return URL(string: "https://www.soundcloud.com/veritaswtf/")
        case .github: return URL(string: "https://www.github.com/veritasdev/battlebuddy")
        }
    }
    func deeplinkUrl() -> URL? {
        switch self {
        case .twitch: return URL(string: "twitch://stream/veritas")
        case .twitter: return URL(string: "twitter://user?screen_name=veriitasgames")
        case .youtube: return URL(string: "vnd.youtube://www.youtube.com/channel/UCkS33XH4KH0IqD2S2-f7ovA")
        case .spotify: return nil
        case .website: return nil
        case .discord: return nil
        case .instagram: return URL(string: "instagram://user?username=veritaswtf")
        case .soundcloud: return URL(string: "soundcloud://users:517515741")
        case .github: return nil
        }
    }
}
