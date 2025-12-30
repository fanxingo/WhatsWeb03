//
//  ChatTextCellView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/29.
//

import SwiftUI

struct ChatTextCellView: View {
    let message: ChatMessageModel
    let isSelf: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isSelf {
                Spacer()
                // 时间在气泡左侧
                CustomText(
                    text: message.time,
                    fontName: Constants.FontString.medium,
                    fontSize: 10,
                    colorHex: "#AEAEAEFF"
                )
                .padding(.bottom, 2)

                // 文本气泡
                CustomText(
                    text: message.content,
                    fontName: Constants.FontString.medium,
                    fontSize: 14,
                    colorHex: "#101010FF"
                )
                .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                .background(Color(hex: "#71FF89FF"))
                .cornerRadius(10)
                .fixedSize(horizontal: false, vertical: true) // 保证高度自适应

                
            } else {
                // 文本气泡
                CustomText(
                    text: message.content,
                    fontName: Constants.FontString.medium,
                    fontSize: 14,
                    colorHex: "#101010FF"
                )
                .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                .background(Color(hex: "#FFFFFFFF"))
                .cornerRadius(10)
                .fixedSize(horizontal: false, vertical: true)


                // 时间在气泡右侧
                CustomText(
                    text: message.time,
                    fontName: Constants.FontString.medium,
                    fontSize: 10,
                    colorHex: "#AEAEAEFF"
                )
                .padding(.bottom, 2)
                Spacer()
            }
        }
    }
}
