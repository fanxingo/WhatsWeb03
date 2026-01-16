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
    @State private var webItem : WebItem?
    @State private var isEdit = false
    @State private var currentURL: URL?
    
    @StateObject private var recentCacheManager = RecentCacheManager.shared
    
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var settings: SettingsManager
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View{
        ZStack{
            VStack(spacing:8){
                TitleView(showFullPayScreen: $showFullPayScreen, title: "Chat".localized())
                SearchView()
                WebGridView()
                HStack{
                    LineSpace(title: "Recently used".localized())
                    Spacer()
                    if !recentCacheManager.recentItems.isEmpty {
                        Button(action: {
                            isEdit.toggle()
                        }) {
                            CustomText(
                                text: isEdit ? "Cancel".localized() : "Edit".localized(),
                                fontName: Constants.FontString.semibold,
                                fontSize: 14,
                                colorHex: isEdit ? "#FF4545FF" : "#7D7D7DFF"
                            )
                        }
                        .padding(.trailing, 12)
                    }
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
        .onAppear {
            recentCacheManager.reloadRecentItems()
        }
        .onDisappear {
            isEdit = false
        }
    }

}

extension ChatView{
    private func openWhatsWithNewView(_ title:String){
        LoadingMaskManager.shared.show()
        MbDoubleOpenManager.shared().clearWebDataStore { success in
            MbDoubleOpenManager.shared().restoreDef(title) { success in
                let newId = title + UUID().uuidString
                if success{
                    MbDoubleOpenManager.shared().clearWebKitData { success in
                        MbDoubleOpenManager.shared().clearWebKitData { success in
                            MbDoubleOpenManager.shared().restoreDef(title) { success in
                                DispatchQueue.main.async {
                                    LoadingMaskManager.shared.hide()
                                    navManager.path.append(
                                        AppRoute.whatsWebView(ids: newId)
                                    )
                                }
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        LoadingMaskManager.shared.hide()
                        navManager.path.append(
                            AppRoute.whatsWebView(ids: newId)
                        )
                    }
                }
            }
        }
    }
    private func openWhatsItemWithRestore(_ productId:String){
        LoadingMaskManager.shared.show()
        MbDoubleOpenManager.shared().clearWebKitData { success in
            MbDoubleOpenManager.shared().clearWebKitData { success in
                MbDoubleOpenManager.shared().restoreWebKitData(withIdentifier: productId) { success in
                    DispatchQueue.main.async {
                        LoadingMaskManager.shared.hide()
                        navManager.path.append(
                            AppRoute.whatsWebView(ids:productId)
                        )
                    }
                }
            }
        }
    }
    private func openWebItemWithRestore(_ webItem: WebItem) {
        LoadingMaskManager.shared.show()
        
        MbDoubleOpenManager.shared().restoreDef(webItem.title) { success in
            if success {
                MbDoubleOpenManager.shared().clearWebKitData { success in
                    MbDoubleOpenManager.shared().clearWebKitData { success in
                        MbDoubleOpenManager.shared().restoreDef(webItem.title) { success in
                            DispatchQueue.main.async {
                                LoadingMaskManager.shared.hide()
                                navManager.path.append(
                                    AppRoute.defWebView(
                                        urlString: webItem.webValue,
                                        titleString: webItem.title
                                    )
                                )
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    LoadingMaskManager.shared.hide()
                    navManager.path.append(
                        AppRoute.defWebView(
                            urlString: webItem.webValue,
                            titleString: webItem.title
                        )
                    )
                }
            }
        }
    }
    
    private func deleteWhatsSaveData(_ item:RecentItem){
        LoadingMaskManager.shared.show()
        MbDoubleOpenManager.shared().deleteSavedWebKitData(withIdentifier: item.productId) { success in
            LoadingMaskManager.shared.hide()
            if success {
                DispatchQueue.main.async {
                    ToastManager.shared.showToast(message: "Deletion successful".localized())
                    recentCacheManager.reloadRecentItems()
                    isEdit.toggle()
                }
            }
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
                    CustomText(text: webItem?.title ?? "Please select a URL".localized(),
                               fontName: Constants.FontString.medium,
                               fontSize: 14,
                               colorHex: (webItem == nil) ? "#A9A9A9FF" : "#101010FF")
                    Spacer()
                }
                .padding(.bottom,6)
                .padding(.horizontal,24)
            }
            Button(action:{
                
                if !settings.hasWhatsPayStatus{
                    showFullPayScreen.toggle()
                    return
                }
                
                if (webItem != nil) {
                    if webItem!.type == 1 {
                        
                        openWhatsWithNewView(webItem!.title)
                        
                    }else{
                        
                        openWebItemWithRestore(webItem!)
                        
                    }
                }
                
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
                        isSelected: webItem?.webValue == item.webValue
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            webItem = item
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
                ForEach(recentCacheManager.recentItems) { item in
                    RecentRowView(item: item,isEdit: isEdit, onDelete: { itemToDelete in
                        PopManager.shared.show(DeletePopView(title: "Do you want to confirm whether to delete \"WhatsApp\"?".localized(), onComplete: {
                            deleteWhatsSaveData(itemToDelete)
                        }))
                    })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            openWhatsItemWithRestore(item.productId)
                        }
                }
            }
            .padding(.bottom,safeBottom + 80)
        }
        .scrollIndicators(.hidden)
        
    }
    
    private struct RecentRowView: View {

        let item: RecentItem
        let isEdit: Bool
        let onDelete: (RecentItem) -> Void

        var body: some View {

            ZStack(alignment: .topTrailing){
                ZStack{
                    Image("chat_icon5")
                        .resizable()
                        .scaledToFit()
                    
                    HStack(spacing: 12) {
                        // 优先显示Documents目录下的图片，否则显示默认icon
                        Group {
                            if let uiImage = loadDocumentImage(for: item.productId) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 34, height: 34)
                                    .cornerRadius(10)
                                    .padding(.bottom,4)
                            } else {
                                Image(item.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 34, height: 34)
                                    .cornerRadius(10)
                                    .padding(.bottom,4)
                            }
                        }

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
                        onDelete(item)
                    }){
                        Image("chat_icon6")
                            .resizable()
                            .frame(width: 20,height: 20)
                    }
                }
            }
        }
        // Helper: 从Documents目录加载图片
        private func loadDocumentImage(for productId: String) -> UIImage? {
            let fileName = "\(productId).png"
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            if let documentsDirectory = paths.first {
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                return UIImage(contentsOfFile: fileURL.path)
            }
            return nil
        }
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
private struct WebItem: Identifiable {
    let id = UUID()
    let type : Int
    let icon: String
    let title: String
    let webValue: String
}


private let webItems: [WebItem] = [
    WebItem(type:1, icon: "chat_item1", title: "WhatsApp", webValue: ""),
    WebItem(type:2, icon: "chat_item2", title: "Telegram", webValue: "https://web.telegram.org/a/"),
    WebItem(type:2, icon: "chat_item3", title: "Instagram", webValue: "https://www.instagram.com/"),
    WebItem(type:2, icon: "chat_item4", title: "X", webValue: "https://x.com/i/flow/login"),
    WebItem(type:2, icon: "chat_item5", title: "TikTok", webValue: "https://www.tiktok.com/login"),
    WebItem(type:2, icon: "chat_item6", title: "Facebook", webValue: "https://m.facebook.com/")
]
