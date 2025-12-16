//
//  MessageList.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/16.
//

import SwiftUI

struct MessageList:View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navManager: NavigationManager
    
    private let isData = true
    @State private var searchTextString : String = ""
    
    private var filteredChats: [ChatItem] {
        if searchTextString.isEmpty {
            return mockChats
        } else {
            return mockChats.filter {
                $0.title.localizedCaseInsensitiveContains(searchTextString)
            }
        }
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                SearchView()
                if isData {
                    ChatListView()
                } else {
                    NoDataView()
                }
                Spacer()
            }
        }
        .background(
            Color(hex: "#FBFFFCFF")
        )
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .dismissKeyboardOnTap()
        .navigationModifiersWithRightButton(title: "Message Backup".localized(), onBack: {
            dismiss()
        }, rightButtonImage: "nav_question_image") {
            navManager.path.append(AppRoute.backupTutorial)
        }
    }
}

extension MessageList{
    @ViewBuilder
    private func SearchView() -> some View{
        ZStack{
            Image("message_icon1")
                .resizable()
                .scaledToFit()
            HStack{
                Image("message_icon2")
                TextField("Search For The Chat History You Are Looking For".localized(), text: $searchTextString)
                    .foregroundColor(Color(hex: "#101010FF"))
                    .font(.system(size: 12, weight: .medium))
                Spacer()
            }
            .padding(.horizontal,24)
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
    }
    
    @ViewBuilder
    private func NoDataView() -> some View{
        VStack(spacing: 0){
            
            Image("message_icon3")
                .scaledToFit()
            
            CustomText(text: "No Backup Chats At The Moment".localized(), fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#AEAEAEFF")
                .multilineTextAlignment(.center)
                .padding(.horizontal,20)
                .fixedSize()
            
            Button(action:{
                navManager.path.append(AppRoute.backupTutorial)
            }){
                CustomText(text: "Backup Chats".localized(), fontName: Constants.FontString.semibold, fontSize: 14, colorHex: "#FFFFFFFF")
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(
                        Color(hex: "#00B81CFF")
                    )
                    .cornerRadius(30)
            }
            .padding(.top,30)
        }
        .padding(.top,160)
    }
    
    @ViewBuilder
    private func ChatListView() -> some View {
        if filteredChats.isEmpty && !searchTextString.isEmpty {
            NoDataView()
        } else {
            List {
                ForEach(filteredChats) { item in
                    MessageListCell(item: item, keyword: searchTextString) {
                        PopManager.shared.show(DeletePopView(title: "确认是否删除", onComplete: {
                            print(item.id)
                        }))
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}

private struct MessageListCell: View {
    let item: ChatItem
    let keyword: String
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(item.avatar)
                .resizable()
                .frame(width: 34, height: 34)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack{
                    HighlightedText(
                        text: item.title,
                        keyword: keyword,
                        font: .custom(Constants.FontString.medium, size: 16),
                        normalColor: Color(hex: "#101010FF"),
                        highlightColor: Color(hex: "#00B81CFF")
                    )
                    Spacer()
                    CustomText(text: item.date, fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#7D7D7DFF")
                }
                CustomText(text: item.subtitle, fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#7D7D7DFF")
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                onDelete()
            } label: {
                Image("message_icon5")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
            }
            .tint(Color.clear)
        }
    }
}

private struct ChatItem: Identifiable {
    let id = UUID()
    let avatar: String
    let title: String
    let subtitle: String
    let date: String
}

private let mockChats: [ChatItem] = [
    ChatItem(avatar: "message_icon4",
             title: "Kathryn Murphy",
             subtitle: "(405) 555-0128",
             date: "2025-06-12"),
    
    ChatItem(avatar: "message_icon4",
             title: "Annette Black",
             subtitle: "$576.28",
             date: "2025-06-12"),
    
    ChatItem(avatar: "message_icon4",
             title: "Family Group",
             subtitle: "Darlene Robertson",
             date: "2025-06-12"),
    
    ChatItem(avatar: "message_icon4",
             title: "Darrell Steward",
             subtitle: "debra.holt@example.com",
             date: "2025-06-12")
]

#Preview {
    MessageList()
}
