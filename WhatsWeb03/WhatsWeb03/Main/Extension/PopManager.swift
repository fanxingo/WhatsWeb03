//
//  PopManager.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/15.
//

import SwiftUI
import Combine

class PopManager: ObservableObject {
    static let shared = PopManager()
    @Published var currentPopup: AnyView? = nil
    
    func show<Content: View>(_ view: Content) {
        DispatchQueue.main.async {
            self.currentPopup = AnyView(view)
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.currentPopup = nil
        }
    }
}
