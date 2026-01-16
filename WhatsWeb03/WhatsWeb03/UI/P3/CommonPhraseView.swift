//
//  CommonPhraseView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/23.
//

import SwiftUI

// 1. 定义数据结构
struct PhraseData: Codable {
    let phrases: [String]
}

struct CommonPhraseView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var phraseList: [String] = []
    
    var body: some View {
        ZStack {
            // 使用 List 实现每行一个数据的布局
            List {
                ForEach(phraseList, id: \.self) { phrase in
                    PhraseRow(phrase: phrase)
                }
            }
            .listStyle(.plain) // 移除自带的 Group 样式
            .environment(\.defaultMinListRowHeight, 0) // 允许更精细的高度控制
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationModifiers(title: "CommonPhrase".localized(), onBack: {
            dismiss()
        })
        .onAppear {
            loadPhrases()
        }
    }
    // 3. 解析 JSON
    private func loadPhrases() {
        if let url = Bundle.main.url(forResource: "commonphrase", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedData = try? JSONDecoder().decode(PhraseData.self, from: data) {
            self.phraseList = decodedData.phrases
        }
    }
}
func PhraseRow(phrase: String) -> some View {
    HStack {
        CustomText(text: phrase, fontName: Constants.FontString.medium, fontSize: 14,colorHex: "#000000FF")
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .background(Color.white)
    .frame(maxWidth: .infinity)
    .cornerRadius(20)
    .overlay(
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color(hex: "#DCDCDCFF"), lineWidth: 1)
    )
    .contentShape(Rectangle())
    .onTapGesture {
        UIPasteboard.general.string = phrase
        ToastManager.shared.showToast(message: "Copy successful".localized())
    }
    // 关键：消除 List 默认边距，并设置外边距（行间距）
    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
}
