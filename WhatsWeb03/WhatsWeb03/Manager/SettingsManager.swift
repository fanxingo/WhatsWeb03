//
//  SettingsManager.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import SwiftUI
import Combine




class SettingsManager: ObservableObject {
    
    @Published var hasWhatsPayStatus: Bool{
        didSet {
            UserDefaultsHelper.set(hasWhatsPayStatus, forKey: Constants.UserDefaultsKeys.hasWhatsPayStatus)
        }
    }

    init() {
        self.hasWhatsPayStatus = UserDefaultsHelper.get(forKey: Constants.UserDefaultsKeys.hasWhatsPayStatus, as: Bool.self) ?? false
    }
}
