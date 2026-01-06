//
//  MessagetDetalis.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/26.
//

import SwiftUI

struct MessageDetails: View {

    var mainModel: ChatItem

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navManager: NavigationManager

    @State private var messages: [ChatMessageModel] = []

    @State private var selectedVideo: ChatMessageModel? = nil
    @State private var selectedImage: ChatMessageModel? = nil

    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack(spacing:0){
            ScrollViewReader { proxy in
                List {
                    ForEach(messages) { message in
                        ChatMessageCell(
                            mainModel:mainModel,
                            message: message,
                            currentUserName: mainModel.userName,
                            pathName: mainModel.pathName,
                            onVideoTap: { videoMessage in
                                selectedVideo = videoMessage
                            },
                            onImageTap: { imageMessage in
                                selectedImage = imageMessage
                            },
                            onAudioTap: { mp3Name in
                                let audioPath = FileDefManager.getFileName(contentName: mp3Name, dicName: mainModel.pathName)
                                let url = URL(fileURLWithPath: audioPath)
                                AudioPlayerManager.shared.play(url: url, id: UUID()) // 可以用消息 ID 或随机 UUID
                            }
                        )
                        .id(message.id)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .scrollIndicators(.hidden)
                .listStyle(.plain)
                
                MessageActionBar(
                    onTop: {
                        if let first = messages.first {
                            withAnimation {
                                proxy.scrollTo(first.id, anchor: .top)
                            }
                        }
                    },
                    onBottom: {
                        if let last = messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    },
                    onMedia: {
                        navManager.path.append(AppRoute.messageMediaCollectionView(mainModel: mainModel))
                    },
                    onDelete: {
                        PopManager.shared.show(DeletePopView(title: "Confirm whether to delete".localized(), onComplete: {
                            FileDefManager.deleteChatFileDirectory(withID: mainModel.id) { isSuccess in
                                if isSuccess{
                                    ToastManager.shared.showToast(message: "Deletion successful".localized())
                                    dismiss()
                                }
                            }
                        }))
                    }
                )
                .padding(.top,12)
                .frame(maxWidth: .infinity)
                .background(.white)
            }
        }
        .fullScreenColorBackground("#E1FFDEFF", false)
        .navigationModifiers(
            title: mainModel.userName,
            onBack: { dismiss() }
        )
        .onAppear {
            loadData()
        }
        .fullScreenCover(item: $selectedVideo) { video in
            VideoScreenView(selectModel: video, pathName: mainModel.pathName){
                selectedVideo = nil
                navManager.path.append(AppRoute.messageMediaCollectionView(mainModel: mainModel))
            }
        }
        .fullScreenCover(item: $selectedImage) { image in
            ImageScreenView(selectModel: image, items: mainModel.messageList.filter { $0.type == .img }, pathName: mainModel.pathName){
                selectedImage = nil
                navManager.path.append(AppRoute.messageMediaCollectionView(mainModel: mainModel))
            }
        }
    }

    private func loadData() {
        messages = mainModel.messageList
    }

}

struct MessageActionBar: View {
    let onTop: () -> Void
    let onBottom: () -> Void
    let onMedia: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack{
            Spacer()
            Button(action: onTop){
                VStack{
                    Image("message_icon7")
                        .resizable()
                        .frame(width: 24,height: 24)
                    CustomText(text: "Top".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#00B81CFF")
                }
            }
            Spacer()
            Button(action: onBottom){
                VStack{
                    Image("message_icon8")
                        .resizable()
                        .frame(width: 24,height: 24)
                    CustomText(text: "Bottom".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#00B81CFF")
                }
            }
            Spacer()
            Button(action: onMedia){
                VStack{
                    Image("message_icon9")
                        .resizable()
                        .frame(width: 24,height: 24)
                    CustomText(text: "Media".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#00B81CFF")
                }
            }
            Spacer()
            Button(action: onDelete){
                VStack{
                    Image("message_icon10")
                        .resizable()
                        .frame(width: 24,height: 24)
                    CustomText(text: "Delete".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#FF4545FF")
                }
            }
            Spacer()
        }
    }
}

struct ChatMessageCell: View {
    let mainModel: ChatItem
    let message: ChatMessageModel
    let currentUserName: String
    let pathName: String

    let onVideoTap: ((ChatMessageModel) -> Void)?
    let onImageTap: ((ChatMessageModel) -> Void)?
    let onAudioTap: ((String) -> Void)?

    private var isSentByCurrentUser: Bool {
        message.userName != currentUserName
    }

    @ViewBuilder
    var body: some View {
        switch message.type {

        case .none:
            ChatNoneCellView(text: message.content)

        case .message:
            ChatTextCellView(
                message: message,
                isSelf: isSentByCurrentUser
            )
            
        case .img:
            ChatImageCellView(
                mainModel:mainModel,
                message: message,
                isSelf: isSentByCurrentUser,
                onTap: { imageMessage in
                    onImageTap?(imageMessage)
                }
            )
            .onTapGesture {
                onImageTap?(message)
            }

        case .video:
            ChatVideoCellView(
                mainModel:mainModel,
                message: message,
                isSelf: isSentByCurrentUser,
                onTap: { videoMessage in
                    onVideoTap?(videoMessage)
                }
            )


        case .audio:
            ChatAudioCellView(
                message: message,
                pathName: pathName,
                isSelf: isSentByCurrentUser
            )

        case .doc, .unDoc:
            ChatDocCellView(
                message: message,
                pathName: pathName,
                isSelf: isSentByCurrentUser
            )

        case .map:
            ChatMapCellView(
                message: message,
                isSelf: isSentByCurrentUser
            )

        }
    }
}
