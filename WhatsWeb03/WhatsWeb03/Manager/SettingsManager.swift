//
//  SettingsManager.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import SwiftUI
import Combine

extension SettingsManager{
    //是否开启用户锁
    var hasPassword: Bool {
        return userPassword.count == 4
    }
}
class SettingsManager: ObservableObject {
    
    // MARK: 用户订阅状态
    @Published var hasWhatsPayStatusTest: Bool{
        didSet {
            UserDefaultsHelper.set(hasWhatsPayStatusTest, forKey: Constants.UserDefaultsKeys.hasWhatsPayStatusTest)
        }
    }
    
    // MARK: 用户锁相关数据
    @Published var userPassword: String {
        didSet {
            UserDefaultsHelper.set(userPassword, forKey: Constants.AppLockKeys.userPassword)
        }
    }
    
    @Published var userQuestion1: String {
        didSet {
            UserDefaultsHelper.set(userQuestion1, forKey: Constants.AppLockKeys.userQuestion1)
        }
    }

    @Published var userQuestion2: String {
        didSet {
            UserDefaultsHelper.set(userQuestion2, forKey: Constants.AppLockKeys.userQuestion2)
        }
    }

    @Published var userQuestion3: String {
        didSet {
            UserDefaultsHelper.set(userQuestion3, forKey: Constants.AppLockKeys.userQuestion3)
        }
    }
    
    // MARK: - Init
    init() {
        self.hasWhatsPayStatusTest = UserDefaultsHelper.get(forKey: Constants.UserDefaultsKeys.hasWhatsPayStatusTest, as: Bool.self) ?? false
        
        self.userPassword = UserDefaultsHelper.get(forKey: Constants.AppLockKeys.userPassword, as: String.self) ?? ""
        
        self.userQuestion1 = UserDefaultsHelper.get(forKey: Constants.AppLockKeys.userQuestion1,as: String.self) ?? ""

        self.userQuestion2 = UserDefaultsHelper.get(forKey: Constants.AppLockKeys.userQuestion2,as: String.self) ?? ""

        self.userQuestion3 = UserDefaultsHelper.get(forKey: Constants.AppLockKeys.userQuestion3,as: String.self) ?? ""
    }
}

