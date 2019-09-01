//
//  AppDelegate.swift
//  BattleBuddy
//
//  Created by Mike on 5/31/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

// TODO: Docs for all classes!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SessionDelegate {
    var window: UIWindow?
    let tabBarController = BaseTabBarController()

    func applicationDidFinishLaunching(_ application: UIApplication) {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.Theme.background
        self.window?.rootViewController = LoadingViewController()

        Fabric.with([Crashlytics.self])
        ThemeManager.configureAppearance()
        DependencyManager.shared.sessionManager.initializeSession()

        self.window?.makeKeyAndVisible()
    }

    // SessionDelegate

    func sessionDidFinishLoading() {
        let itemsVC = ItemsMenuViewController()
        itemsVC.title = NSLocalizedString("items", comment: "")
        itemsVC.tabBarItem.image = UIImage(named: "items")
        let itemsNC = BaseNavigationController(rootViewController: itemsVC)

        let learnVC = LearnMenuViewController()
        learnVC.title = NSLocalizedString("learn", comment: "")
        learnVC.tabBarItem.image = UIImage(named: "learn")
        let learnNC = BaseNavigationController(rootViewController: learnVC)

        let moreVC = MoreMenuViewController()
        moreVC.title = NSLocalizedString("more", comment: "")
        moreVC.tabBarItem.image = UIImage(named: "more")
        let moreNC = BaseNavigationController(rootViewController: moreVC)

        self.tabBarController.setViewControllers([itemsNC, learnNC, moreNC], animated: false)
        self.window?.rootViewController = self.tabBarController

        DependencyManager.shared.feedbackManager.promptForReviewIfNecessary()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let dependencyManager = DependencyManager.shared
        dependencyManager.twitchManager.refreshTwitchInfo()
        dependencyManager.metadataManager.updateGlobalMetadata { (globalMetadata) -> Void in }
    }
}

