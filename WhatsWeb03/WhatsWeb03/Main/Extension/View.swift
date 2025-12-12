//
//  View.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import SwiftUI

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
