//
//  SceneDelegate.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import UIKit
import Network

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var checkNetworkWindow: UIWindow?
    var networkMonitor = NetworkMonitor()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        networkMonitor.startMonitoring { [weak self] status in
            switch status {
            case .satisfied:
                self?.removeNetworkErrorWindow()
//                print("네트워크 연결됨")
            case .unsatisfied:
                self?.loadNetworkErrorWindow(on: scene)
//                print("네트워크 끊김")
            default:
                break
            }
        }

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            let vc = LaunchViewController()
            window.rootViewController = vc
            self.window = window
            window.makeKeyAndVisible()
        }
//        if let windowScene = scene as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//
//            let nav = UINavigationController(rootViewController: ChattingViewController())
//            window.rootViewController = nav
//            self.window = window
//            window.makeKeyAndVisible()
//        }
//        if let windowScene = scene as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//
//            let vc = MainTabBarController()
//            window.rootViewController = vc
//            self.window = window
//            window.makeKeyAndVisible()
//        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        networkMonitor.stopMonitoring()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    private func loadNetworkErrorWindow(on scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.windowLevel = .statusBar
            window.makeKeyAndVisible()
            let networkErrorView = NetWorkErrorView(frame: window.bounds)
            window.addSubview(networkErrorView)
            self.checkNetworkWindow = window
        }
    }
    private func removeNetworkErrorWindow() {
        checkNetworkWindow?.resignKey()
        checkNetworkWindow?.isHidden = true
        checkNetworkWindow = nil
    }
}

