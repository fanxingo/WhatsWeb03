//
//  View.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import SwiftUI

// 1. 定义一个 Key
private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets = .init()
}

// 2. 扩展 EnvironmentValues
extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        get { self[SafeAreaInsetsKey.self] }
        set { self[SafeAreaInsetsKey.self] = newValue }
    }
}

extension View {
    /// 获取整个安全区域 Insets
    var safeInsets: UIEdgeInsets {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.safeAreaInsets ?? .zero
    }
    
    /// 顶部安全区
    var safeTop: CGFloat {
        safeInsets.top
    }
    
    /// 底部安全区
    var safeBottom: CGFloat {
        safeInsets.bottom
    }
    
    /// 左侧安全区
    var safeLeft: CGFloat {
        safeInsets.left
    }
    
    /// 右侧安全区
    var safeRight: CGFloat {
        safeInsets.right
    }
}

extension View {
    func fullScreenBackground(_ imageName: String,_ ignore: Bool) -> some View {
        self.modifier(FullScreenBackground(imageName: imageName,ignore: ignore))
    }
    func fullScreenColorBackground(_ hex: String,_ ignore: Bool) -> some View {
        self.modifier(FullScreenColorBackground(hex: hex,ignore: ignore))
    }
}
extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTapModifier())
    }
}
