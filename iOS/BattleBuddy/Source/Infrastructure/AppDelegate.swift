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
        defer { self.window?.makeKeyAndVisible() }

        // If we're running unit tests, bail out here as we don't want any
        // more real app-launch stuff to be processed.
        guard NSClassFromString("XCTestCase") == nil else { return }

        ThemeManager.configureAppearance()
        DependencyManagerImpl.shared.accountManager.initializeSession()
        Fabric.with([Crashlytics.self])
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

        DependencyManagerImpl.shared.feedbackManager.promptForReviewIfNecessary()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let dependencyManager = DependencyManagerImpl.shared
        dependencyManager.twitchManager.refreshTwitchInfo()
        dependencyManager.metadataManager.updateGlobalMetadata { (globalMetadata) -> Void in }
    }
}

