//
//  AppDelegate.swift
//  pulley
//
//  Created by eli on 2021/05/01.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainVC = MainVC().then {
            $0.reactor = MainReactor(
                imagePickerService: ImagePickerService(),
                canvasService: CanvasService()
            )
        }
        let mainNavigation = UINavigationController(rootViewController: mainVC)
        
        self.window?.rootViewController = mainNavigation
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

