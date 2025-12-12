//
//  AppDelegate.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import UIKit
import SwiftUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UserDefaultsHelper.set(true, forKey: Constants.UserDefaultsKeys.hasWhatsPayStatus)
//        NetworkMonitor.shared.startMonitoring { [self] in
//
//        }
        return true
    }
}
