//
//  AppDelegate.swift
//  fourspoon
//
//  Created by Ryan Kotzebue on 11/3/17.
//  Copyright © 2017 Ryan Kotzebue. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setAppearence()
        
        self.window?.rootViewController = InitialViewController()
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func setAppearence() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.font : UIFont(name: "AmericanTypewriter-Condensed", size: 28)!
        ]
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.141, green: 0.200, blue: 0.482, alpha: 1.00)
        UINavigationBar.appearance().isTranslucent = false
    }


}

