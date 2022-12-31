//
//  AppDelegate.swift
//  ComponentSample
//
//  Created by 小田島 直樹 on 2022/12/31.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootVC: RootViewController = .instantiateFromStoryboard()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }
}

