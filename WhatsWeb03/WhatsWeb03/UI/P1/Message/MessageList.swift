//
//  MessageList.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/16.
//

import SwiftUI
import Foundation



struct MessageList:View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navManager: NavigationManager
    
    @State private var searchTextString : String = ""
    @State private var chatItems: [ChatItem] = []
    
    private var filteredChats: [ChatItem] {
        if searchTextString.isEmpty {
            return chatItems
        } else {
            return chatItems.filter {
                $0.userName.localizedCaseInsensitiveContains(searchTextString)
            }
        }
    }
    
    
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                SearchView()
                if !chatItems.isEmpty {
                    ChatListView()
                } else {
                    NoDataView()
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(
            Color(hex: "#FBFFFCFF")
        )
        .dismissKeyboardOnTap()
        .navigationModifiersWithRightButton(title: "Message Backup".localized(), onBack: {
            dismiss()
        }, rightButtonImage: "nav_question_image") {
            navManager.path.append(AppRoute.backupTutorial)
        }
        .onAppear {
            loadChatItems()
        }
        .onReceive(NotificationCenter.default.publisher(for: .didReceiveSharedFileURL)) { _ in
            loadChatItems()
        }
    }
    
    private func loadChatItems() {
        let directories = FileDefManager.listChatFileDirectories()
        chatItems = directories.map { dirName in
            ChatModelManager.configData(pathName: dirName)
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
                        
                        PopManager.shared.show(DeletePopView(title: "Confirm whether to delete".localized(), onComplete: {
                            FileDefManager.deleteChatFileDirectory(withID: item.id) { isSuccess in
                                if isSuccess{
                                    loadChatItems()
                                    ToastManager.shared.showToast(message: "Deletion successful".localized())
                                }
                            }
                        }))
                        
                    } onTap: {
                        navManager.path.append(AppRoute.messageDetalis(mainModel: item))
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
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 10) {
            Image("message_icon4")
                .resizable()
                .frame(width: 34, height: 34)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack{
                    HighlightedText(
                        text: item.userName,
                        keyword: keyword,
                        font: .custom(Constants.FontString.medium, size: 16),
                        normalColor: Color(hex: "#101010FF"),
                        highlightColor: Color(hex: "#00B81CFF")
                    )
                    Spacer()
                    CustomText(text: item.lastTime, fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#7D7D7DFF")
                }
                CustomText(text: item.lastMessage, fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#7D7D7DFF")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity,alignment: .leading)
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
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
    }
}



struct ChatModelManager {
    static func configData(pathName: URL) -> ChatItem {
        // 获取聊天文件名列表
        //ChatContentName @"_chat.txt"
        //ChatFileUserName @"ChatFileUserName.txt"
        let unresolvedString = FileDefManager.getChatMessage(directoryPath: pathName.path(), fileName: "_chat.txt")
        let userName = FileDefManager.getChatMessage(directoryPath: pathName.path(), fileName: "ChatFileUserName.txt")
        
        var messageList: [ChatMessageModel] = []
        var lastMessage = ""
        var lastTime = ""
        var currentUserName = userName
        
        let lines = unresolvedString.components(separatedBy: .newlines)
        let regexPattern = #"\[(.*?)\] (.*)"#
        let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
        
        for line in lines {
            guard let regex = regex else { continue }
            let nsLine = line as NSString
            let matches = regex.matches(in: line, options: [], range: NSRange(location: 0, length: nsLine.length))
            if let match = matches.first, match.numberOfRanges == 3 {
                let timeRange = match.range(at: 1)
                let contentRange = match.range(at: 2)
                let time = nsLine.substring(with: timeRange)
                let content = nsLine.substring(with: contentRange)
                
                let components = content.components(separatedBy: ":")
                if components.count > 1 {
                    let userNameInLine = components[0]
                    let messageContent = components.dropFirst().joined(separator: ":")
                    let messageType = pickType(for: messageContent)
                    let chatMessage = ChatMessageModel(time: time, userName: userNameInLine, content: messageContent, type: messageType)
                    messageList.append(chatMessage)
                    lastMessage = messageContent
                    lastTime = time
                    currentUserName = userNameInLine
                }
            }
        }
        
        return ChatItem(id: pathName.lastPathComponent,
                        pathName: pathName.path(),
                        userName: currentUserName,
                        lastTime: lastTime,
                        lastMessage: lastMessage,
                        messageList: messageList)
    }
    
    static func pickType(for content: String) -> MessageType {
        if content.contains("已成为联系人") ||
            content.contains("消息和通话都进行端到端加密。对话之外的任何人，甚至包含 WhatsApp 都无法读取或收听。") ||
            content.contains("Messages and calls are end-to-end encrypted. Only people in this chat can read, listen to, or share them.")
        {
            return .none
        } else if content.contains("<") && (content.contains(".jpg>") ||
                                            content.contains(".png>") ||
                                            content.contains(".jpeg>") ||
                                            content.contains(".webp>") ||
                                            content.contains(".gif")) {
            return .img
        } else if content.contains("<") && content.contains(".mp4>") {
            return .video
        } else if content.contains("<") && (content.contains(".opus>") ||
                                            content.contains(".mp3>")) {
            return .audio
        } else if content.contains("<") && (content.contains(".docx") ||
                                            content.contains(".doc") ||
                                            content.contains(".xlsx") ||
                                            content.contains(".xls") ||
                                            content.contains(".pptx") ||
                                            content.contains(".ppt") ||
                                            content.contains(".pdf") ||
                                            content.contains(".odt") ||
                                            content.contains(".odp") ||
                                            content.contains(".csv") ||
                                            content.contains(".rtf") ||
                                            content.contains(".txt")) {
            return .doc
        } else if content.contains("<") && content.contains(">") && content.contains(".") {
            return .unDoc
        } else if content.contains("https://maps.google.com") {
            return .map
        } else {
            return .message
        }
    }
}


enum MessageType: Int, Hashable {
    case none = 0
    case message
    case img
    case video
    case audio
    case doc
    case unDoc
    case map
}

struct ChatItem: Identifiable,Hashable {
    let id: String
    let pathName: String
    let userName: String
    let lastTime: String
    let lastMessage: String
    let messageList: [ChatMessageModel]
}
struct ChatMessageModel: Identifiable, Hashable {
    let id = UUID()
    let time: String
    let userName: String
    let content: String
    let type: MessageType
}
