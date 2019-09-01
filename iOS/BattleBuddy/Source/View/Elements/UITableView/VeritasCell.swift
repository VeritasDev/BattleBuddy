//
//  VeritasCell.swift
//  BattleBuddy
//
//  Created by Mike on 7/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import WebKit

class VeritasCell: UITableViewCell {
    let containerStackView = BaseStackView()
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "veritas_logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let logoStackView = BaseStackView(axis: .horizontal)
    let twitchStreamView: WKWebView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .default, reuseIdentifier: nil)

        twitchStreamView.backgroundColor = .black

        contentView.addSubview(twitchStreamView)
        twitchStreamView.pinToContainer()
    }

    func loadStream() {

        WebKitUtils.clearWKWebViewCache{
            self.twitchStreamView.load(URLRequest(url: URL(string: "https://embed.twitch.tv/?channel=veritas&theme=light&layout=video")!))
        }
    }
}
