//
//  BaseWebViewController.swift
//  BattleBuddy
//
//  Created by Mike on 7/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: UIViewController {
    let webView: WKWebView =  {
        let webView = WKWebView()
        webView.backgroundColor = .white
        return webView
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
    }
}
