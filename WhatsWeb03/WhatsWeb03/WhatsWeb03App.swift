//
//  WhatsWeb03App.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import SwiftUI
import Combine

struct WhatsWeb03App: View  {
    
    @StateObject var settings = SettingsManager()
    @StateObject var navManager = NavigationManager()
    @StateObject private var popManager = PopManager.shared
    
    var body: some View {
        LoadingView()
            .environmentObject(settings)
            .environmentObject(navManager)
            .environmentObject(popManager)
    }
}

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
//    @Published var onForgetPasswordComplete: (() -> Void)? = nil
}
