//
//  AnalyticsManager.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2026/1/6.
//

import SwiftUI
import FirebaseAnalytics

class AnalyticsManager {
    
    static func saveBurialPoint(eventName: String, check: Bool) {
        if check {
            let hasLogged = UserDefaults.standard.bool(forKey: eventName)
            if !hasLogged {
                logEvent(eventName: eventName)
                UserDefaults.standard.set(true, forKey: eventName)
            }
        } else {
            logEvent(eventName: eventName)
        }
    }

    private static func logEvent(eventName: String) {
        // Firebase Analytics
        Analytics.logEvent(eventName, parameters: nil)
    }
}
