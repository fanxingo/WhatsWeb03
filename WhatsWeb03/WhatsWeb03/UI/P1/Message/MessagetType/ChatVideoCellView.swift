//
//  ChatVideoCellView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/29.
//

import SwiftUI
import AVFoundation

struct ChatVideoCellView: View {
    
    @EnvironmentObject var navManager: NavigationManager
    
    let mainModel: ChatItem
    let message: ChatMessageModel
    let isSelf: Bool
    
    let onTap: (ChatMessageModel) -> Void

    @State private var thumbnail: UIImage? = nil
    


    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isSelf { Spacer() }

            // 气泡 + 时间横向排列
            HStack(alignment: .bottom, spacing: 8) {
                if isSelf {
                    // 时间在气泡左侧
                    CustomText(
                        text: message.time,
                        fontName: Constants.FontString.medium,
                        fontSize: 10,
                        colorHex: "#AEAEAEFF"
                    )
                    .padding(.bottom, 2)

                    videoBubbleView()
                } else {
                    videoBubbleView()

                    // 时间在气泡右侧
                    CustomText(
                        text: message.time,
                        fontName: Constants.FontString.medium,
                        fontSize: 10,
                        colorHex: "#AEAEAEFF"
                    )
                    .padding(.bottom, 2)
                }
            }
            .onTapGesture {
                onTap(message)
            }

            if !isSelf { Spacer() }
        }
        .onAppear {
            loadThumbnail()
        }
    }

    @ViewBuilder
    private func videoBubbleView() -> some View {
        if let thumb = thumbnail {
            ZStack {
                Image(uiImage: thumb)
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .cornerRadius(10)

                // 播放按钮
                Image("message_icon6")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .shadow(radius: 3)
            }
            .padding(12)
            .background(isSelf ? Color(hex: "#71FF89FF") : Color(hex: "#FFFFFFFF"))
            .frame(maxHeight: 250)
            .cornerRadius(10)
        }
    }

    private func loadThumbnail() {
        let filePath = FileDefManager.getFileName(contentName: message.content, dicName: mainModel.pathName)
        let fileURL = URL(fileURLWithPath: filePath)

        DispatchQueue.global(qos: .background).async {
            let asset = AVURLAsset(url: fileURL)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            if let cgImage = try? imgGenerator.copyCGImage(at: .zero, actualTime: nil) {
                let uiImg = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    self.thumbnail = uiImg
                }
            }
        }
    }
}
