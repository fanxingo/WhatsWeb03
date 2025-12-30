//
//  Untitled.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/22.
//

import SwiftUI
import Combine

final class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var message: String = ""
    @Published var isShowing: Bool = false
    
    private init() {}
    
    func showToast(message: String) {
        DispatchQueue.main.async {
            self.message = message
            withAnimation {
                self.isShowing = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isShowing = false
                }
            }
        }
    }
}

struct ToastModifier: ViewModifier {
    @ObservedObject var toastManager = ToastManager.shared
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if toastManager.isShowing {
                Text(toastManager.message)
                    .foregroundColor(Color(hex: "#00B81CFF"))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#E1FFDEFF"))
                    .cornerRadius(20)
                    .transition(.opacity)
                    .zIndex(1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
        }
    }
}

extension View {
    func toast() -> some View {
        self.modifier(ToastModifier())
    }
}
