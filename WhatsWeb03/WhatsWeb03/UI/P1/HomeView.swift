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
    @EnvironmentObject var settings: SettingsManager
    
    @State private var showFullPayScreen = false
    
    @State private var showInputLockView = false
    
    @State private var route: AppRoute?
    
    var body: some View{
        ZStack{
            VStack(spacing: 8){
                
                TitleView(showFullPayScreen: $showFullPayScreen, title: "Home".localized())
                

                Button(action:{
                    currentTab = .chat
                }){
                    ButtonAction()
                }
                .padding(.top,8)
                
                HStack{
                    Button(action:{
                        if settings.hasPassword {
                            showInputLockView = true
                            route = AppRoute.messageList;
                        }else{
                            navManager.path.append(AppRoute.messageList)
                        }
                    }){
                        ItemView(bgImg: "home_linebg_item2",
                                 iconImg: "home_icon2",
                                 title: "Message Backup".localized(),
                                 desc: "Data backup".localized())
                    }
                    Button(action:{
                        navManager.path.append(AppRoute.appLockView)
                    }){
                        ItemView(bgImg: "home_linebg_item2",
                                 iconImg: "home_icon3",
                                 title: "Application Lock".localized(),
                                 desc: "Protect your privacy".localized())
                    }
                }

                LineSpace(title: "More features".localized())
                
                Button(action: {
                    navManager.path.append(
                        AppRoute.userIconView
                    )
                }){
                    ItemView2(bgImg: "home_linebg_item3",
                              iconImg: "home_icon4",
                              title: "Social profile picture".localized())
                }
                Button(action: {
                    navManager.path.append(AppRoute.generateQRCodesView)
                }){
                    ItemView2(bgImg: "home_linebg_item3",
                              iconImg: "home_icon5",
                              title: "Generate QR code".localized())
                }
                Button(action: {
                    navManager.path.append(AppRoute.remindView)
                }){
                    ItemView2(bgImg: "home_linebg_item3",
                              iconImg: "home_icon6",
                              title: "Schedule reminders".localized())
                }
                Spacer()
            }
            .padding(.top,safeTop)
            .padding(.horizontal,16)
        }
        .fullScreenBackground("loding_bgimage",false)
        .fullScreenCover(isPresented: $showFullPayScreen) {
            PayView()
        }
        .fullScreenCover(isPresented: $showInputLockView) {
            AppLockInputView { action in
                switch action {
                case .forgetPassword:
                    showInputLockView = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                        navManager.path.append(AppRoute.forgetPasswordView)
                    }
                case .success:
                    showInputLockView = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if let route {
                            navManager.path.append(route)
                            self.route = nil   // ⭐️ 非常重要
                        }
                    }
                case .cancel:
                    showInputLockView = false
                }
            }
        }
    }
}


extension HomeView{
    @ViewBuilder
    private func ButtonAction() -> some View {
        ZStack{
            Image("home_linebg_item1")
                .resizable()
                .scaledToFit()
            HStack{
                Image("home_icon1")
                    .frame(width: 40,height: 40)
                VStack(alignment: .leading){
                    CustomText(text: "Chat".localized(),
                               fontName: Constants.FontString.semibold,
                               fontSize: 20,
                               colorHex: "#101010FF")
                    CustomText(text: "Dual Chat".localized(),
                               fontName: Constants.FontString.medium,
                               fontSize: 14,
                               colorHex: "#7D7D7DFF")
                }
                Spacer()
                Image("home_arrow")
                    .resizable()
                    .frame(width: 24,height: 24)
            }
            .padding(.horizontal,24)
            .padding(.bottom,8)
        }
    }
    
    private struct ItemView:View {
        var bgImg : String
        var iconImg : String
        var title : String
        var desc : String
        
        var body: some View{
            ZStack{
                Image(bgImg)
                    .resizable()
                    .scaledToFit()
                HStack{
                    Image(iconImg)
                        .resizable()
                        .frame(width: 40,height: 40)
                    VStack(alignment: .leading){
                        CustomText(text: title, fontName: Constants.FontString.medium,fontSize: 14, colorHex: "#101010FF")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        CustomText(text: desc, fontName: Constants.FontString.medium,fontSize: 12, colorHex: "#7D7D7DFF")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    Spacer()
                }
                .padding(.leading,14)
                .padding(.trailing,14)
                .padding(.bottom,8)

            }
        }
    }
    
    private struct ItemView2:View {
        var bgImg : String
        var iconImg : String
        var title : String

        var body: some View{
            ZStack{
                Image(bgImg)
                    .resizable()
                    .scaledToFit()
                HStack(spacing:10){
                    Image(iconImg)
                        .resizable()
                        .frame(width: 34,height: 34)
                    CustomText(text: title, fontName: Constants.FontString.medium,fontSize: 14, colorHex: "#101010FF")
                    Spacer()
                    Image("home_arrow")
                        .resizable()
                        .frame(width: 20,height: 20)
                }
                .padding(.horizontal,24)
                .padding(.bottom,8)

            }
        }
    }
}
//
//#Preview {
//
//    @Previewable @StateObject var settings = SettingsManager()
//    @Previewable @StateObject var navManager = NavigationManager()
//    @Previewable @StateObject var popManager = PopManager.shared
//    
//    TabMainView()
//        .environmentObject(settings)
//        .environmentObject(navManager)
//        .environmentObject(popManager)
//}
