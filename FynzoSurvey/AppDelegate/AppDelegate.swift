//
//  AppDelegate.swift
//  MyMusicPlayer
//
//  Created by Mohd Maruf on 14/01/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
//import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let buttonColor = #colorLiteral(red: 0, green: 0.5607843137, blue: 0.9333333333, alpha: 1)
    let appDarkGray = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    let appThemeColor = #colorLiteral(red: 0, green: 0.5607843137, blue: 0.9333333333, alpha: 1)
    
    class var shared: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return AppDelegate()
        }
        return appDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        if !(AppUserDefaults.value(forKey: .id, fallBackValue: false) as? String ?? "").isEmpty {
            moveToDashboard()
        }
       
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    
    func moveToLogin() {
        let navController = UINavigationController.instantiate(fromAppStoryboard: .Authentication)
        navController.viewControllers = [LoginViewController.instantiate(fromAppStoryboard: .Authentication)]
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func moveToDashboard() {
        let navController = UINavigationController.instantiate(fromAppStoryboard: .Authentication)
        navController.viewControllers = [HomeViewController.instantiate(fromAppStoryboard: .Home)]
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}

