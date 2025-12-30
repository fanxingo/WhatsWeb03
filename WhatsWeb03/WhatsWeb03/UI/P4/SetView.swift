//
//  Untitled.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//

import SwiftUI

struct SettingItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let action: () -> Void
}

struct SetView: View{
    
    @EnvironmentObject var navManager: NavigationManager
    
    @Binding var currentTab: CustomTab
    
    @State private var showFullPayScreen = false
    
    var body: some View{
        ZStack{
            VStack{
                TitleView(showFullPayScreen: $showFullPayScreen, title: "Settings".localized())
                Button(action: {
                    showFullPayScreen = true
                }){
                    VipItemView()
                }
                LineSpace(title: "Settings".localized())
                    .padding(.top,8)
                
                SettingItemListView(items: [
                    SettingItem(
                        icon: "set_icon3",
                        title: "Password Lock".localized()
                    ) {
                        navManager.path.append(AppRoute.appLockView)
                    }
                ])
                
                LineSpace(title: "General".localized())
                    .padding(.top,8)

                SettingItemListView(items: [
                    SettingItem(
                        icon: "set_icon5",
                        title: "Privacy Policy".localized()
                    ) {
                        UIApplication.shared.open(URL(string: "https://www.baidu.com")!)
                    },
                    SettingItem(
                        icon: "set_icon6",
                        title: "Terms of Use".localized()
                    ) {
                        UIApplication.shared.open(URL(string: "https://www.baidu.com")!)
                    },
                    SettingItem(
                        icon: "set_icon7",
                        title: "Restore Subscription".localized()
                    ) {
                        print("Restore Subscription")
                    },
                    SettingItem(
                        icon: "set_icon8",
                        title: "Feedback".localized()
                    ) {
                        navManager.path.append(AppRoute.feedbackView)
                    }
                ])
                Spacer()
            }
            .padding(.top,safeTop)
            .padding(.horizontal,16)
        }
        .fullScreenBackground("loding_bgimage",true)
        .fullScreenCover(isPresented: $showFullPayScreen) {
            PayView()
        }
    }
}

extension SetView {
    
    @ViewBuilder
    private func VipItemView() -> some View {
        ZStack(alignment: .topTrailing){
            ZStack{
                Image("set_icon1")
                    .resizable()
                    .scaledToFit()
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        CustomText(
                            text: "Upgrade To Premium Version".localized(),
                            fontName: Constants.FontString.semibold,
                            fontSize: 16,
                            colorHex: "#00660FFF"
                        )
                        CustomText(
                            text: "Unlock all PRO permissions".localized(),
                            fontName: Constants.FontString.medium,
                            fontSize: 12,
                            colorHex: "#00660FFF"
                        )
                    }
                    Spacer()
                }
                .padding(.leading,16)
                .padding(.trailing,80)

            }
            .frame(maxWidth: .infinity)
            .padding(.top,20)

            Image("set_icon2")
                .resizable()
                .scaledToFit()
                .frame(width: 106,height: 108)
                .padding(.trailing,10)
        }
    }
    
    @ViewBuilder
    private func SettingItemListView(items: [SettingItem]) -> some View {
        VStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in

                Button(action: {
                    items[index].action()
                }) {
                    HStack(spacing: 12) {
                        Image(items[index].icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)

                        CustomText(
                            text: items[index].title,
                            fontName: Constants.FontString.medium,
                            fontSize: 14,
                            colorHex: "#101010FF"
                        )

                        Spacer()

                        Image("home_arrow")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if items.count > 1 && index != items.count - 1 {
                    Divider()
                        .padding(.horizontal, 16)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#FFFFFF80"))
        .cornerRadius(20)
    }
}

#Preview {
    @Previewable @StateObject var settings = SettingsManager()
    @Previewable @StateObject var navManager = NavigationManager()
    @Previewable @StateObject var popManager = PopManager.shared
    
    TabMainView()
        .environmentObject(settings)
        .environmentObject(navManager)
        .environmentObject(popManager)
}
