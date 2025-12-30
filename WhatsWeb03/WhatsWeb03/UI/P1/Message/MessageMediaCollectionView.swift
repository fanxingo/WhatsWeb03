//
//  MediaPreView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/29.
//

import SwiftUI
import AVFoundation
import Kingfisher

struct MessageMediaCollectionView : View {
    
    @Environment(\.dismiss) var dismiss
    
    var mainModel: ChatItem
    
    @State private var selectedMessage: ChatMessageModel? = nil

    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing: CGFloat = 3 * 5
        let itemWidth = (screenWidth - totalSpacing) / 4
        
        let columns = Array(repeating: GridItem(.fixed(itemWidth), spacing: 5), count: 4)
        
        let filteredMessages = mainModel.messageList.filter { $0.type == .img || $0.type == .video }
        
        ZStack{
            ScrollView {
                LazyVGrid(columns: columns, spacing: 5) {
                    
                    ForEach(filteredMessages) { message in
                        
                        let filePath = FileDefManager.getFileName(contentName: message.content, dicName: mainModel.pathName)
                        
                        if message.type == .img {
                            
                            KFImage(URL(fileURLWithPath: filePath))
                                .placeholder {
                                    Image("loding_bgimage")
                                        .resizable()
                                        .frame(width: itemWidth, height: itemWidth)
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: itemWidth, height: itemWidth)
                                .clipped()
                                .id(message.id)
                                .onTapGesture {
                                    selectedMessage = message
                                }
                            
                            
                        } else if message.type == .video {
                            
                            VideoThumbnailView(videoPath: filePath, width: itemWidth, id: message.id)
                                .frame(width: itemWidth, height: itemWidth)
                                .clipped()
                                .id(message.id)
                                .onTapGesture {
                                    selectedMessage = message
                                }
                        }
                    }
                }
                .padding(.horizontal, 0)
            }
        }
        .fullScreenColorBackground("#FBFFFC", false)
        .navigationModifiers(
            title: "Media Preview".localized(),
            onBack: { dismiss() }
        )
        .fullScreenCover(item: $selectedMessage) { message in
            // 这里的 message 就是你点击的那一个，绝对不会为空
            if message.type == .img {
                ImageScreenView(selectModel: message, items: mainModel.messageList.filter { $0.type == .img }, pathName: mainModel.pathName) {
                    selectedMessage = nil
                }
            } else {
                VideoScreenView(selectModel: message,pathName: mainModel.pathName){
                    selectedMessage = nil
                }
            }
        }
    }
}

struct VideoThumbnailView: View {
    let videoPath: String
    let width: CGFloat
    let id: UUID
    
    @State private var thumbnailImage: UIImage? = nil
    @State private var durationText: String = ""
    
    var body: some View {
        Group {
            if let image = thumbnailImage {
                ZStack(alignment: .bottomTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: width) // 确保 Image 本身尺寸明确
                    
                    if !durationText.isEmpty {
                        // 建议先换成原生 Text 测试
                        Text(durationText)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(4)
                            .padding([.bottom, .trailing], 4)
                    }
                }
            } else {
                Image("loding_bgimage")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: width, height: width)
        .clipped()
        // 关键点：使用 task 并绑定 id，当 id 变化（视图复用）时会自动重启任务
        .task(id: id) {
            await loadVideoData()
        }
    }
    
    // 使用 Swift 并发模型更安全
    private func loadVideoData() async {
        // 重置旧状态，防止显示上一个视频的数据
        self.thumbnailImage = nil
        self.durationText = ""
        
        let url = URL(fileURLWithPath: videoPath)
        let asset = AVURLAsset(url: url)
        
        do {
            // 异步获取时长
            let duration = try await asset.load(.duration)
            let totalSeconds = Int(CMTimeGetSeconds(duration).rounded())
            
            // 只有当秒数大于0时才显示
            if totalSeconds > 0 {
                let minutes = totalSeconds / 60
                let seconds = totalSeconds % 60
                self.durationText = String(format: "%02d:%02d", minutes, seconds)
            }
            
            // 异步生成缩略图
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try await imgGenerator.image(at: .zero).image
            self.thumbnailImage = UIImage(cgImage: cgImage)
            
        } catch {
            print("Failed to load video metadata: \(error)")
        }
    }
}
