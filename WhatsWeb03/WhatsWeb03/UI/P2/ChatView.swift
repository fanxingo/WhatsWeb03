//
//  ChatView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//
import SwiftUI

struct ChatView: View{
    
    @Binding var currentTab: CustomTab
    
    @State private var showFullPayScreen = false
    @State private var titleWebString = "请选择网址".localized()
    @State private var isEdit = false
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View{
        ZStack{
            VStack(spacing:8){
                TitleView(showFullPayScreen: $showFullPayScreen, title: "Chat".localized())
                SearchView()
                WebGridView()
                HStack{
                    LineSpace(title: "最近使用".localized())
                    Spacer()
                    Button(action:{
                        isEdit = !isEdit
                    }){
                        CustomText(text: isEdit ? "Cancel".localized() : "Edit".localized(),
                                   fontName: Constants.FontString.semibold,
                                   fontSize: 14,
                                   colorHex: isEdit ? "#FF4545FF" : "#7D7D7DFF")
                    }
                    .padding(.trailing,12)
                }
                RecentListView()
                Spacer()
            }
            .padding(.top,safeTop)
            .padding(.horizontal,16)
        }
        .fullScreenBackground("loding_bgimage",true)
        .fullScreenCover(isPresented: $showFullPayScreen) {
            PayView()
        }
        .onDisappear {
            isEdit = false
        }

    }
}

extension ChatView{
    @ViewBuilder
    private func SearchView() -> some View {
        HStack{
            ZStack{
                Image("chat_icon1")
                    .resizable()
                    .scaledToFit()
                HStack{
                    Image("chat_icon4")
                        .resizable()
                        .frame(width: 20,height: 20)
                    CustomText(text: titleWebString,
                               fontName: Constants.FontString.medium,
                               fontSize: 12,
                               colorHex: titleWebString == "请选择网址".localized() ? "#A9A9A9FF" : "#101010FF")
                    Spacer()
                }
                .padding(.bottom,6)
                .padding(.horizontal,24)
            }
            Button(action:{
                print("Sure tapped, value:", titleWebString)
            }){
                ZStack{
                    CustomText(text: "Sure".localized(),
                               fontName: Constants.FontString.semibold,
                               fontSize: 14,
                               colorHex: "#363636FF")
                    .padding(.bottom,6)
                }
                .padding()
                .background(
                    Image("chat_icon2")
                        .resizable(capInsets: EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                )
            }
            
        }
        .padding(.top,8)
    }

    @ViewBuilder
    private func WebGridView() -> some View {
        ZStack{
            Image("chat_icon3")
                .resizable()
                .scaledToFit()
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(webItems) { item in
                    WebItemView(
                        item: item,
                        isSelected: titleWebString == item.webValue
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            titleWebString = item.webValue
                        }
                    }
                }
            }
            .padding(.horizontal,20)
            .padding(.bottom,6)
        }
    }
    
    @ViewBuilder
    private func RecentListView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(recentItems) { item in
                    RecentRowView(item: item,isEdit: isEdit)
                }
            }
            .padding(.bottom,safeBottom + 80)
        }
        .scrollIndicators(.hidden)
        
    }
}

private struct WebItemView: View {

    let item: WebItem
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 10) {
            ZStack{
                Image(item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                Image("chat_item_def")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                
            }
            CustomText(text: item.title, fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#101010FF")
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
    }
    
}

private struct RecentRowView: View {

    let item: RecentItem
    let isEdit: Bool

    var body: some View {

        ZStack(alignment: .topTrailing){
            ZStack{
                Image("chat_icon5")
                    .resizable()
                    .scaledToFit()
                
                HStack(spacing: 12) {
                    Image(item.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)

                    VStack(alignment: .leading, spacing: 4) {
                        CustomText(
                            text: item.title,
                            fontName: Constants.FontString.medium,
                            fontSize: 14,
                            colorHex: "#101010FF"
                        )
                    }
                    Spacer()
                    Image("home_arrow")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal,20)
                .padding(.bottom,6)
            }
            .padding(.top,10)
            
            if isEdit{
                Button(action:{
                    PopManager.shared.show(DeletePopView(title: "确认是否删除“WhatsApp”？", onComplete: {
                        print(item.id)
                    }))
                }){
                    Image("chat_icon6")
                        .resizable()
                        .frame(width: 20,height: 20)
                }
            }
        }
        .contentShape(Rectangle()) // 整行可点
        .onTapGesture {
            print("点击最近使用:", item.title)
        }
    }
}


private struct WebItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let webValue: String
}

private struct RecentItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

private let webItems: [WebItem] = [
    WebItem(icon: "chat_item1", title: "WhatsApp", webValue: "https://web.whatsapp.com"),
    WebItem(icon: "chat_item2", title: "Telegram", webValue: "https://web.telegram.org"),
    WebItem(icon: "chat_item3", title: "Instagram", webValue: "https://www.instagram.com"),
    WebItem(icon: "chat_item4", title: "X", webValue: "https://x.com"),
    WebItem(icon: "chat_item5", title: "TikTok", webValue: "https://www.tiktok.com"),
    WebItem(icon: "chat_item6", title: "Facebook", webValue: "https://www.facebook.com")
]

private let recentItems: [RecentItem] = [
    RecentItem(icon: "chat_item1", title: "WhatsApp Web"),
    RecentItem(icon: "chat_item2", title: "Telegram Web"),
    RecentItem(icon: "chat_item1", title: "WhatsApp Web"),
    RecentItem(icon: "chat_item1", title: "WhatsApp Web"),
    RecentItem(icon: "chat_item1", title: "WhatsApp Web"),
    RecentItem(icon: "chat_item2", title: "Telegram Web"),
    RecentItem(icon: "chat_item1", title: "WhatsApp Web"),
    RecentItem(icon: "chat_item1", title: "WhatsApp Web"),
    RecentItem(icon: "chat_item1", title: "WhatsApp Web"),
    RecentItem(icon: "chat_item2", title: "Telegram Web"),
    RecentItem(icon: "chat_item1", title: "WhatsApp Web"),
    RecentItem(icon: "chat_item1", title: "WhatsApp Web")
]

#Preview {
    @Previewable @StateObject var settings = SettingsManager()
    @Previewable @StateObject var navManager = NavigationManager()
    @Previewable @StateObject var popManager = PopManager.shared
    
    TabMainView()
        .environmentObject(settings)
        .environmentObject(navManager)
        .environmentObject(popManager)
}
