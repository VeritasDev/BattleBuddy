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
    let dependencyManager = DependencyManagerImpl.shared

    override init() {
        super.init()

        dependencyManager.assembleDependencies(self)
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.Theme.background
        self.window?.rootViewController = LoadingViewController()
        defer { self.window?.makeKeyAndVisible() }

        // If we're running unit tests, bail out here as we don't want any
        // more real app-launch stuff to be processed.
        guard NSClassFromString("XCTestCase") == nil else { return }

        ThemeManager.configureAppearance()
        dependencyManager.accountManager().initializeSession()
        Fabric.with([Crashlytics.self])
    }

    // SessionDelegate

    func sessionDidFinishLoading() {
        reloadRootViewController()
        DependencyManagerImpl.shared.feedbackManager().promptForReviewIfNecessary()
    }

    func reloadRootViewController() {
        let itemsVC = ItemsMenuViewController()
        itemsVC.title = "items".local()
        itemsVC.tabBarItem.image = UIImage(named: "items")
        let itemsNC = BaseNavigationController(rootViewController: itemsVC)

        let learnVC = LearnMenuViewController()
        learnVC.title = "learn".local()
        learnVC.tabBarItem.image = UIImage(named: "learn")
        let learnNC = BaseNavigationController(rootViewController: learnVC)

        let moreVC = MoreMenuViewController()
        moreVC.title = "more".local()
        moreVC.tabBarItem.image = UIImage(named: "more")
        let moreNC = BaseNavigationController(rootViewController: moreVC)

        self.tabBarController.setViewControllers([itemsNC, learnNC, moreNC], animated: false)
        self.window?.rootViewController = self.tabBarController
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        dependencyManager.twitchManager().refreshTwitchInfo()
        dependencyManager.metadataManager().updateGlobalMetadata { (globalMetadata) -> Void in }
    }
}

