//
//  PopManager.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/15.
//

import SwiftUI
import Combine

enum PopAnimationStyle {
    case fade
    case bottom
}

class PopManager: ObservableObject {
    static let shared = PopManager()
    @Published var currentPopup: AnyView? = nil
    @Published var animationStyle: PopAnimationStyle = .fade
    
    func show<Content: View>(_ view: Content, style: PopAnimationStyle = .fade) {
        DispatchQueue.main.async {
            withAnimation {
                self.animationStyle = style
                self.currentPopup = AnyView(view)
            }
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            withAnimation {
                self.currentPopup = nil
            }
        }
    }
}
