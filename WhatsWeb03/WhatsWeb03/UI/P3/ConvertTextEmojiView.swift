//
//  ConvertTextEmojiView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/23.
//

import SwiftUI

struct ConvertTextEmojiView : View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var inputString : String = ""
    @State private var inputEmoji : String = "❤️"
    @State private var createString : String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 16){
                BorderedTextEditor(text: $inputString,
                                   placeholder: "Edit the text you need".localized(),
                                   cornerRadius: 20,
                                   minHeight: 100,
                                   maxHeight: 100)
                    .padding(.top,12)
                
                HStack(spacing:16){
                    CustomText(text: "emojis".localized(), fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#000000FF")
                    TextField("", text: $inputEmoji)
                        .multilineTextAlignment(.center)
                        .frame(width: 65, height: 35)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#DCDCDCFF"), lineWidth: 1)
                        )
                        .onChange(of: inputEmoji) { oldValue,newValue in
                            if let lastChar = newValue.last {
                                inputEmoji = String(lastChar)
                            } else {
                                inputEmoji = ""
                            }
                        }
                    Spacer()
                    
                    Button(action:{
                        // 获取每个字符
                        var result = ""
                        for char in inputString.uppercased() {
                            // 根据字符调用 LetterTextUtil 对应方法生成 ASCII
                            var letterPattern: String = ""
                            switch char {
                            case "A": letterPattern = LetterTextUtil.letterA(char.description)
                            case "B": letterPattern = LetterTextUtil.letterB(char.description)
                            case "C": letterPattern = LetterTextUtil.letterC(char.description)
                            case "D": letterPattern = LetterTextUtil.letterD(char.description)
                            case "E": letterPattern = LetterTextUtil.letterE(char.description)
                            case "F": letterPattern = LetterTextUtil.letterF(char.description)
                            case "G": letterPattern = LetterTextUtil.letterG(char.description)
                            case "H": letterPattern = LetterTextUtil.letterH(char.description)
                            case "I": letterPattern = LetterTextUtil.letterI(char.description)
                            case "J": letterPattern = LetterTextUtil.letterJ(char.description)
                            case "K": letterPattern = LetterTextUtil.letterK(char.description)
                            case "L": letterPattern = LetterTextUtil.letterL(char.description)
                            case "M": letterPattern = LetterTextUtil.letterM(char.description)
                            case "N": letterPattern = LetterTextUtil.letterN(char.description)
                            case "O": letterPattern = LetterTextUtil.letterO(char.description)
                            case "P": letterPattern = LetterTextUtil.letterP(char.description)
                            case "Q": letterPattern = LetterTextUtil.letterQ(char.description)
                            case "R": letterPattern = LetterTextUtil.letterR(char.description)
                            case "S": letterPattern = LetterTextUtil.letterS(char.description)
                            case "T": letterPattern = LetterTextUtil.letterT(char.description)
                            case "U": letterPattern = LetterTextUtil.letterU(char.description)
                            case "V": letterPattern = LetterTextUtil.letterV(char.description)
                            case "W": letterPattern = LetterTextUtil.letterW(char.description)
                            case "X": letterPattern = LetterTextUtil.letterX(char.description)
                            case "Y": letterPattern = LetterTextUtil.letterY(char.description)
                            case "Z": letterPattern = LetterTextUtil.letterZ(char.description)
                            case "0": letterPattern = LetterTextUtil.letter0(char.description)
                            case "1": letterPattern = LetterTextUtil.letter1(char.description)
                            case "2": letterPattern = LetterTextUtil.letter2(char.description)
                            case "3": letterPattern = LetterTextUtil.letter3(char.description)
                            case "4": letterPattern = LetterTextUtil.letter4(char.description)
                            case "5": letterPattern = LetterTextUtil.letter5(char.description)
                            case "6": letterPattern = LetterTextUtil.letter6(char.description)
                            case "7": letterPattern = LetterTextUtil.letter7(char.description)
                            case "8": letterPattern = LetterTextUtil.letter8(char.description)
                            case "9": letterPattern = LetterTextUtil.letter9(char.description)
                            default:
                                letterPattern = String(char)
                            }
                            
                            // 替换里面的占位符为 emoji
                            let emojiChar = inputEmoji.isEmpty ? "" : inputEmoji
                            let replaced = letterPattern.map { $0.isWhitespace ? String($0) : emojiChar }.joined()
                            result += replaced + "\n" // 每个字符换行
                        }
                        createString = result
                    }) {
                        CustomText(text: "Generate".localized(),
                                   fontName: Constants.FontString.semibold,
                                   fontSize: 14,
                                   colorHex: "#FFFFFFFF")
                            .frame(maxWidth: 120,maxHeight: 34)
                            .background(Color(hex: "#00B81CFF"))
                            .cornerRadius(10)
                    }
                }

                if !createString.isEmpty {
                    VStack(spacing: 0){
                        HStack{
                            CustomText(
                                text: "Result".localized(),
                                fontName: Constants.FontString.medium,
                                fontSize: 14,
                                colorHex: "#101010FF"
                            )
                            Spacer()
                            Button(action:{
                                UIPasteboard.general.string = createString
                                ToastManager.shared.showToast(message: "Copy successful".localized())
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
                            .disabled(true)
                            .font(.custom(Constants.FontString.medium, size: 8))
                            .padding(16)
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "#DCDCDCFF"), lineWidth: 1)
                    )
                    .frame(maxWidth: .infinity)
                    .safeAreaPadding(.bottom)
                }
                Spacer()
            }
            .padding(.horizontal,16)
            
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationModifiers(title: "Text to emoji".localized(), onBack: {
            dismiss()
        })
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
    }
}
