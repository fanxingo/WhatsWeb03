//
//  a.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/23.
//

import SwiftUI

// 1. 定义数据结构，用于解析 JSON
private struct EmojiData: Codable {
    let emojis: [String]
}

struct EmojisView: View {
    @Environment(\.dismiss) var dismiss
    @State private var emojiList: [String] = []

    var body: some View {
        ZStack {
            ScrollView {
                // 使用我们自定义的 FlowLayout
                FlowLayout(spacing: 12) {
                    ForEach(emojiList, id: \.self) { emoji in
                        CustomText(text: emoji, fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#101010FF")
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "#DCDCDCFF"), lineWidth: 1)
                            )
                            .onTapGesture {
                                UIPasteboard.general.string = emoji
                                ToastManager.shared.showToast(message: "复制成功".localized())
                            }
                    }
                }
            }
            .padding(.top,16)
            .padding(.horizontal,16)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationModifiers(title: "Emojis".localized(), onBack: {
            dismiss()
        })
        .onAppear {
            loadEmojis()
        }
    }

    private func loadEmojis() {
        if let url = Bundle.main.url(forResource: "emojis", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedData = try? JSONDecoder().decode(EmojiData.self, from: data) {
            self.emojiList = decodedData.emojis
        }
    }
}

#Preview {
    EmojisView()
}
