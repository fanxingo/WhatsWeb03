//
//  AppDelegate.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import UIKit
import FirebaseAnalytics
import FirebaseCore
import AppTrackingTransparency
import AdServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        NetworkMonitor.shared.startMonitoring { [self] in
            configFIRApp()
            uploadServerData()
            reloadProducts()
        }
        return true
    }
    
    func configFIRApp(){
        if (FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        AnalyticsManager.saveBurialPoint(eventName: "first_in_load", check: true)
    }
    
    func reloadProducts(){
        Task {
            await SubscriptionProductStore.shared.preloadProducts(ids: [
                "whats04_3dsub_week2",
                "whats04_3dsub_week1",
                "whats04_sub_week1",
                "whats04_3dsub_year1",
                "whats04_sub_year1"
            ])
        }
    }
    
    
    func uploadServerData(){
        
        UserDefaultsHelper.set(true, forKey: Constants.UserDefaultsKeys.hasIsUserStatus)
        
        var token = "notoken"
        
        do {
            token = try AAAttribution.attributionToken()
        } catch {
            print("Failed to get attribution token: \(error)")
        }
        
        let params = [
            "uid": UUIDTool.getUUIDInKeychain(),
            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown",
            "token": token,
            "app_instance_id": Analytics.appInstanceID() ?? "no_id"
        ]
        let urlString = BaseUrl("/a/ads")
        
        NetworkManager.shared.sendPOST2Request(urlString: urlString, parameters: params) { result in
            switch result {
            case .success(let responseString):
                print("\(responseString)")
            case .failure(let error):
                print("请求失败：\(error.localizedDescription)")
            }
            self.reloadServerData()
        }
    }
    func reloadServerData(){
        let params = [
            "uid": UUIDTool.getUUIDInKeychain(),
            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown",
        ]
        let urlString = BaseUrl("/a/member")
        
        NetworkManager.shared.sendPOSTRequest(urlString: urlString, parameters: params) { result in
            switch result {
            case .success(let jsonDict):
                print("请求成功，返回数据：\(jsonDict)")
                guard let code = jsonDict["code"] as? Int, code == 20000,
                      let data = jsonDict["data"] as? [String: Any],
                      let isUser = data["is_user"] as? Int,
                      let isSubscribed = data["is_subscribed"] as? Int else {
                    return
                }
                print("订阅状态：\(isSubscribed)")
                let status = Int(isSubscribed)
                
                if status == 1{
                    UserDefaultsHelper.set(true, forKey: Constants.UserDefaultsKeys.hasWhatsPayStatus)
                }else{
                    UserDefaultsHelper.set(false, forKey: Constants.UserDefaultsKeys.hasWhatsPayStatus)
                }
                
                if isUser == 1{
                    UserDefaultsHelper.set(true, forKey: Constants.UserDefaultsKeys.hasIsUserStatus)
                }else{
                    UserDefaultsHelper.set(false, forKey: Constants.UserDefaultsKeys.hasIsUserStatus)
                }
                
            case .failure(let error):
                print("请求失败：\(error.localizedDescription)")
            }
        }
    }
}
