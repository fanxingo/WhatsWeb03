//
//  ChatImageCellView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/29.
//

import SwiftUI

struct ChatImageCellView: View {
    
    @EnvironmentObject var navManager: NavigationManager
    
    let mainModel: ChatItem
    let message: ChatMessageModel
    let isSelf: Bool
    let onTap: (ChatMessageModel) -> Void

    @State private var uiImage: UIImage? = nil
    

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isSelf { Spacer() }

            HStack(alignment: .bottom, spacing: 8) {
                if isSelf {
                    // 时间在图片左侧
                    CustomText(
                        text: message.time,
                        fontName: Constants.FontString.medium,
                        fontSize: 10,
                        colorHex: "#AEAEAEFF"
                    )
                    .padding(.bottom, 2)

                    imageBubbleView()
                } else {
                    imageBubbleView()

                    // 时间在图片右侧
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
            loadImage()
        }
    }

    @ViewBuilder
    private func imageBubbleView() -> some View {
        if let img = uiImage {
            Image(uiImage: img)
                .resizable()
                .scaledToFit()
                .clipped()
                .cornerRadius(10)
                .padding(12)
                .background(isSelf ? Color(hex: "#71FF89FF") : Color(hex: "#FFFFFFFF"))
                .frame(maxHeight: 250)
                .cornerRadius(10)
        }
    }

    private func loadImage() {
        let filePath = FileDefManager.getFileName(contentName: message.content, dicName: mainModel.pathName)
        let fileURL = URL(fileURLWithPath: filePath)

        if let data = try? Data(contentsOf: fileURL), let img = UIImage(data: data) {
            self.uiImage = img
        }
    }
}
