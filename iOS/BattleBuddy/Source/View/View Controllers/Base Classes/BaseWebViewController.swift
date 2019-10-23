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
    lazy var webView: WKWebView =  {
        let webView = WKWebView()
        webView.backgroundColor = UIColor.Theme.background
        webView.navigationDelegate = self
        return webView
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.Theme.background
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

    func injectedCSS() -> String? {
        return nil
    }
}

extension BaseWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let css = injectedCSS() else { return }
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(jsString, completionHandler: nil)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}
