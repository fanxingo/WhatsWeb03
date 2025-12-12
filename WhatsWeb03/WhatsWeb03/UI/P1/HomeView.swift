//
//  HomeView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//
import SwiftUI

struct HomeView: View{
    @Binding var currentTab: CustomTab
    @EnvironmentObject var navManager: NavigationManager
    
    @State private var showFullPayScreen = false
    
    var body: some View{
        ZStack{
            Color(.red)
            Button (action:{
//                navManager.path.append(AppRoute.testView)
                showFullPayScreen = true
            }){
                Text("Push")
            }
        }
        .fullScreenCover(isPresented: $showFullPayScreen) {
            PayView()
        }
        
    }
}
