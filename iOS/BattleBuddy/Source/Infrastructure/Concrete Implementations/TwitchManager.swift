//
//  TwitchRequestHelper.swift
//  BattleBuddy
//
//  Created by Mike on 8/7/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class TwitchManager {
    private let baseUrl = "https://api.twitch.tv/helix/"
    private let headers: [String: String] = ["Client-ID": "4fgs4wy7qqlk01ju7ad7vr3skcskqi"]
    private let streamsRoute = "streams"
    private lazy var requestor = { return DependencyManager.shared.httpRequestor }()
    private var summary = TwitchSummary()

    private func generateUrlWithParams(routeComponents: [String] = [], params: [String: String] = [:]) -> String {
        let paramsComponents: [String] = params.keys.map { "\($0)=\(params[$0]!)" }
        let route = routeComponents.joined(separator: "/")
        let query = paramsComponents.count > 0 ? "?" + paramsComponents.joined(separator: "&") : ""
        return baseUrl + route + query
    }

    private func getInfoForChannels(_ channels: [TwitchChannel]) {
        var url = baseUrl + "streams?"

        for channel in channels {
            url += (channel == channels.first) ? "user_id=\(channel.userId())" : "&user_id=\(channel.userId())"
        }

        requestor.sendGetRequest(url: url, headers: headers) { response in
            guard let json: [String: Any] = response else { return }

            guard let channels = json["data"] as? [[String: Any]] else { return }

            for channelJson in channels {
                guard let usernameString = channelJson["user_name"] as? String,
                    let channel = TwitchChannel(rawValue: usernameString.lowercased()),
                    let id = channelJson["id"] as? String,
                    let name = channelJson["user_name"] as? String,
                    let state = channelJson["type"] as? String else { continue }
                let isLive = state == "live"
                self.summary.channelInfo[channel] = TwitchChannelInfo(twitchId: id, channelName: name, isLive: isLive)
            }

        }
    }

    func refreshTwitchInfo() {
        getInfoForChannels(TwitchChannel.allCases)
    }

    func isChannelLive(_ channel: TwitchChannel) -> Bool {
        if let channelInfo = summary.channelInfo[channel] {
            return channelInfo.isLive
        } else {
            return false
        }
    }
}
