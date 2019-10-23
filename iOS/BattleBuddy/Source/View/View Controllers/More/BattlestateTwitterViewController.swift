//
//  BattlestateTwitterViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/22/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BattlestateTwitterViewController: BaseWebViewController {
    let html = """
<meta name='viewport' content='initial-scale=1.0'/>
<a class="twitter-timeline" data-theme="dark" href="https://twitter.com/bstategames">Tweets by Battlestate Games</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
"""

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "attributions_bsg".local()

        webView.loadHTMLString(html, baseURL: nil)
    }

    override func injectedCSS() -> String? {
        return """
        .twitter-timeline { width: 100vw !important; } body { background-color: black; }
        """
    }
}
