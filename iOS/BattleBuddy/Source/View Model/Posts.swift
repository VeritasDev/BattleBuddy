//
//  Posts.swift
//  BattleBuddy
//
//  Created by Mike on 7/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

final class BallisticsPost: PostConfiguration {
    var title: String? = Localized("ballistics")

    var elements: [PostElement] {
        return [
            PostElementImage(image: UIImage(named: "card_hero_ballistics")!, height: 200.0),
            PostElementHeader(localizedTitle: Localized("ballistics_title"), authorName: "Veritas", publishDate: Date(timeIntervalSince1970: 1563025929)),
            PostElementBody(body: "ballistics_body_1".local()),
            PostElementBody(body: "ballistics_body_2".local()),
            PostElementImage(image: UIImage(named: "card_hero_armor")!, height: 200.0),
            PostElementBodyTitle(title: "ballistics_body_2_1_title".local()),
            PostElementBody(body: "ballistics_body_2_1".local()),
            PostElementBodyTitle(title: "ballistics_body_2_2_title".local()),
            PostElementBody(body: "ballistics_body_2_2_1".local()),
            PostElementYouTube(videoId: "3KbFMHp4NOE", height: 260.0),
            PostElementBody(body: "ballistics_body_2_2_2".local()),
            PostElementBody(body: "ballistics_body_2_2_2".local()),
            PostElementImage(image: UIImage(named: "ballistics_post_1")!, height: 200.0),
            PostElementBodyTitle(title: "ballistics_body_2_3_title".local()),
            PostElementBody(body: "ballistics_body_2_3".local()),
            PostElementBodyTitle(title: "ballistics_body_2_4_title".local()),
            PostElementBody(body: "ballistics_body_2_4".local()),
            PostElementBodyTitle(title: "ballistics_body_2_5_title".local()),
            PostElementBody(body: "ballistics_body_2_5".local()),
            PostElementYouTube(videoId: "XDK-aLkGvkA", height: 260.0),
            PostElementBodyTitle(title: "ballistics_body_3_title".local()),
            PostElementBody(body: "ballistics_body_3".local()),
            ]
    }
}

final class UpcomingFeaturesPost: PostConfiguration {
    var title: String? = "upcoming_features".local()

    var elements: [PostElement] {
        return [
            PostElementImage(image: UIImage(named: "upcoming_hero")!, height: 300.0),
            PostElementHeader(localizedTitle: "coming_soon".local(), authorName: "Veritas", publishDate: Date(timeIntervalSince1970: 1566640516)),
            PostElementBody(body: "upcoming_body_1".local()),
        ]
    }
}

// TODO: v1.1?
final class TraderPost: PostConfiguration {
    var title: String?
    var trader: Trader
    let fbManager = DependencyManagerImpl.shared.firebaseManager

    init(_ trader: Trader) {
        self.trader = trader

        title = trader.local()
    }

    var elements: [PostElement] {
        return [
            PostElementImage(image: trader.heroImage(), height: 300.0),
            PostElementSubHeader(localizedTitle: Localized("trader_ll1")),
            PostElementSubHeader(localizedTitle: Localized("trader_ll2")),
            PostElementSubHeader(localizedTitle: Localized("trader_ll3")),
            PostElementSubHeader(localizedTitle: Localized("trader_ll4"))
        ]
    }
}

// TODO: v1.1?
final class HealthAndStatusEffectsPost: PostConfiguration {
    var title: String? = Localized("health")

    var elements: [PostElement] {
        let heroImage = UIImage(named: "card_hero_health")!
        let imageElement = PostElementImage(image: heroImage, height: 300.0)

        let publishDate = Date(timeIntervalSince1970: 1564606381)
        let headerElement = PostElementHeader(localizedTitle: Localized("health_title"), authorName: "Veritas", publishDate: publishDate)
        let bodyElement1 = PostElementBody(body: Localized("health_body_1"))

        return [imageElement, headerElement, bodyElement1]
    }
}
