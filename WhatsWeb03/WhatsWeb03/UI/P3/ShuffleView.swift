//
//  ShuffleView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/23.
//

import SwiftUI

struct ShuffleView:View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var inputString : String = ""
    @State private var createString : String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 16){
                BorderedTextEditor(text: $inputString,
                                   placeholder: "编辑您需要的文本".localized(),
                                   cornerRadius: 20,
                                   minHeight: 100,
                                   maxHeight: 100)
                    .padding(.top,12)
                
                Button(action:{
                    {
                        guard !inputString.isEmpty else { return }

                        // 将输入文本拆分为字符数组
                        let characters = Array(inputString)

                        // 随机打乱顺序
                        let shuffledCharacters = characters.shuffled()

                        // 重新组合成字符串
                        let shuffledString = String(shuffledCharacters)

                        // 追加到结果文本框
                        if createString.isEmpty {
                            createString = shuffledString
                        } else {
                            createString += shuffledString
                        }
                    }()
                }){
                    CustomText(text: "生成".localized(),
                               fontName: Constants.FontString.semibold,
                               fontSize: 14,
                               colorHex: "#FFFFFFFF")
                        .frame(maxWidth: 220,maxHeight: 34)
                        .background(Color(hex: "#00B81CFF"))
                        .cornerRadius(10)
                }
                
                VStack(spacing: 0){
                    HStack{
                        CustomText(text: "生成结果".localized(), fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#101010FF")
                        Spacer()
                        Button(action:{
                            UIPasteboard.general.string = createString
                            ToastManager.shared.showToast(message: "复制成功".localized())
                        }){
                            Image("lab_icon12")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding()
                    Divider()
                        .padding(.horizontal,16)
                    
                    TextEditor(text: $createString)
                        .padding(16)
                }
                .background(
                    Color.white
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "#DCDCDCFF"), lineWidth: 1)
                )
                .frame(maxWidth: .infinity)
                .safeAreaPadding(.bottom)
            }
            .padding(.horizontal,16)
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationModifiers(title: "Flip Text".localized(), onBack: {
            dismiss()
        })
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
    }
}
