//
//  SceneDelegate.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import UIKit
import SwiftUI
import ZIPFoundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let contentView = WhatsWeb03App()
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)

            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let url = URLContexts.first?.url else { return }

        //  /UUID()
        print("✅ SceneDelegate 收到分享文件:", url)

        let needAccess = url.startAccessingSecurityScopedResource()
        defer {
            if needAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }
        FileDefManager.handleZipFile(url: url) { result in
            switch result {
            case .success(let destinationURL):
                print("✅ ZIP 解压成功，路径：\(destinationURL)")
                
                FileDefManager.saveZipFileNameToTxt(zipFilePath: url.path, saveTo: destinationURL.path)

                FileDefManager.deleteFile(at: url)
                
                // 在这里通知 SwiftUI 或刷新 UI
                NotificationCenter.default.post(
                    name: .didReceiveSharedFileURL,
                    object: destinationURL
                )

            case .failure(let error):
                print("❌ ZIP 解压失败：\(error.localizedDescription)")
            }
        }
    }
}
extension Notification.Name {
    static let didReceiveSharedFileURL =
        Notification.Name("didReceiveSharedFileURL")
}
