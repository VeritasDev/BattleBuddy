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
    var hasSessionFinishedLaunching: Bool = false

    override init() {
        super.init()

        dependencyManager.assembleDependencies(self)
    }

    // UIApplicationDelegate

    func applicationDidFinishLaunching(_ application: UIApplication)  {
        if #available(iOS 13.0, *) {
            setupApplication()
            return
        }

        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.Theme.background
        self.window?.rootViewController = LoadingViewController()
        defer { self.window?.makeKeyAndVisible() }

        setupApplication()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // dependencyManager.twitchManager().refreshTwitchInfo() TODO: UPDATE FOR NEW TWITCH API
        dependencyManager.metadataManager().updateGlobalMetadata { (globalMetadata) -> Void in }
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // dependencyManager.twitchManager().refreshTwitchInfo() TODO: UPDATE FOR NEW TWITCH API
        dependencyManager.metadataManager().updateGlobalMetadata { (globalMetadata) -> Void in }
    }

    // SessionDelegate

    func sessionDidFinishLoading() {
        reloadRootViewController()
        dependencyManager.feedbackManager().promptForReviewIfNecessary()

        hasSessionFinishedLaunching = true
    }

    // Internal

    func reloadRootViewController() {
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                guard let sceneDelegate = scene.delegate as? SceneDelegate else {
                    continue
                }

                sceneDelegate.reloadRootViewController()
            }
        } else {
            self.tabBarController.setup()
            self.window?.rootViewController = self.tabBarController
        }
    }

    // Private

    private func setupApplication() {
        // If we're running unit tests, bail out here as we don't want any
        // more real app-launch stuff to be processed.
        guard NSClassFromString("XCTestCase") == nil else { return }

        ThemeManager.configureAppearance()
        dependencyManager.accountManager().initializeSession()
        Fabric.with([Crashlytics.self])
    }
}


@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UISceneDelegate {

    var window: UIWindow?

    // UISceneDelegate

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        defer { window.makeKeyAndVisible() }

        window.backgroundColor = UIColor.Theme.background

        if
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            appDelegate.hasSessionFinishedLaunching
        {
            reloadRootViewController()
        } else {
            window.rootViewController = LoadingViewController()
        }
    }

    // Internal

    func reloadRootViewController() {
        guard let window = window else {
            return
        }

        let tabBarController = BaseTabBarController()
        tabBarController.setup()
        window.rootViewController = tabBarController
    }
}


fileprivate extension BaseTabBarController {

    func setup() {
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

        setViewControllers([itemsNC, learnNC, moreNC], animated: false)
    }
}
