//
//  HomeView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//
import SwiftUI

enum CustomTab: Hashable {
    case home, chat, text, mine
}

enum AppRoute: Hashable{
    
    case messageList
    case messageDetalis(mainModel:ChatItem)
    case messageMediaCollectionView(mainModel:ChatItem)
    case appLockView
    case backupTutorial
    case appLockTutorialView
    case forgetPasswordView
    
    case userIconView
    case selectedIconView(iconName:String)
    case generateQRCodesView
    case remindView
    case createRemindView(itemID:UUID?)
    
    case sendQuicklyView
    case artisticFontsView
    case emojisView
    case commonPhraseView
    case translateView
    case repeatingTextView
    case flipTextView
    case shuffleView
    case convertTextEmojiView
    
    case feedbackView
}
extension View {
    func applyRoutes() -> some View {
        self.navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .messageList:
                MessageList()
            case .messageDetalis(let mainModel):
                MessageDetails(mainModel: mainModel)
            case .messageMediaCollectionView(let mainModel):
                MessageMediaCollectionView(mainModel: mainModel)
            case .appLockView:
                AppLockView()
            case .backupTutorial:
                BackupTutorialView()
            case .appLockTutorialView:
                AppLockTutorialView()
            case .forgetPasswordView:
                ForgetPasswordView()
                
            case .userIconView:
                UserIconView()
            case .selectedIconView(let iconName):
                SelectedIconView(iconName: iconName)
            case .generateQRCodesView:
                GenerateQRCodesView()
            case .remindView:
                RemindView()
            case .createRemindView(let itemID):
                CreateRemindView(itemID: itemID)
                
            case .sendQuicklyView:
                SendQuicklyView()
            case .artisticFontsView:
                ArtisticFontsView()
            case .emojisView:
                EmojisView()
            case .commonPhraseView:
                CommonPhraseView()
            case .translateView:
                TranslateView()
            case .repeatingTextView:
                RepeatingTextView()
            case .flipTextView:
                FlipTextView()
            case .shuffleView:
                ShuffleView()
            case .convertTextEmojiView:
                ConvertTextEmojiView()
            case .feedbackView:
                FeedbackView()
            }
        }
    }
}


struct TabMainView: View {
    
    @State private var currentTab: CustomTab = .home

    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var settings: SettingsManager
    @EnvironmentObject var popManager: PopManager
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack(path: $navManager.path) {
                ZStack {
                    switch currentTab {
                    case .home:
                        HomeView(currentTab: $currentTab)
                    case .chat:
                        ChatView(currentTab: $currentTab)
                    case .text:
                        TextView(currentTab: $currentTab)
                    case .mine:
                        SetView(currentTab: $currentTab)
                    }
                }
                .applyRoutes()
                .edgesIgnoringSafeArea(.all)
                

            }
            if navManager.path.isEmpty {
                FloatingTabBar(selection: $currentTab)
                    .padding(.horizontal, 30)
                    .padding(.bottom, safeBottom)
            }
            //弹窗控制器
            if let popup = popManager.currentPopup {
                popup
            }
        }
        .toast()
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct FloatingTabBar: View {
    @Binding var selection: CustomTab
    
    private let tabBarItems: [(tab: CustomTab, title: String, selectedImage: String, unselectedImage: String)] = [
        (.home, "Home".localized(), "tabbar_select1", "tabbar_select_nol1"),
        (.chat, "Chat".localized(), "tabbar_select2", "tabbar_select_nol2"),
        (.text, "Text Lab".localized(), "tabbar_select3", "tabbar_select_nol3"),
        (.mine, "Settings".localized(), "tabbar_select4", "tabbar_select_nol4")
    ]
    
    var body: some View {
        HStack {
            ForEach(tabBarItems, id: \.tab) { item in
                Button(action: {
                    withAnimation {
                        selection = item.tab
                    }
                }) {
                    VStack(spacing: 0) {
                        Image(selection == item.tab ? item.selectedImage : item.unselectedImage)
                            .frame(width: 24, height: 24)
                        CustomText(text: item.title, fontName: Constants.FontString.medium, fontSize: 10, colorHex: selection == item.tab ? "#00B81CFF" : "#A9A9A9FF")
                    }
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom,5)
                }
            }
        }
        .padding(.horizontal,16)
        .background(
            Image("tabbar_groundback")
                .resizable()
                .cornerRadius(20)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}




