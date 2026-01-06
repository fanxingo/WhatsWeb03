//
//  LoadingMaskView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2026/1/4.
//

import SwiftUI
import Combine

final class LoadingMaskManager: ObservableObject {
    static let shared = LoadingMaskManager()
    @Published var isLoading: Bool = false

    private init() {}

    func show() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}

private struct LoadingMaskView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.3)
        }
    }
}

private struct LoadingMaskModifier: ViewModifier {
    @ObservedObject var manager = LoadingMaskManager.shared

    func body(content: Content) -> some View {
        ZStack {
            content

            if manager.isLoading {
                LoadingMaskView()
                    .transition(.opacity)
                    .zIndex(999)
            }
        }
    }
}

extension View {
    func loadingMask() -> some View {
        self.modifier(LoadingMaskModifier())
    }
}
