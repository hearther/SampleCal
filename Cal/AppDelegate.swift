//
//  AppDelegate.swift
//  Cal
//
//  Created by Bunny Lin on 2024/1/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame:UIScreen.main.bounds)
        self.window?.rootViewController =  CalVC()
        
        self.window!.makeKeyAndVisible()
        return true
    }

    

}

