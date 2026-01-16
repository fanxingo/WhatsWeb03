//
//  Untitled.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/23.
//

import SwiftUI

let fanzhuanArray: [String] = [
    "ɐ", "ɐ", "q", "q", "ɔ", "ɔ", "p", "p", "ǝ", "ǝ",
    "ɟ", "ɟ", "ƃ", "ƃ", "ɥ", "ɥ", "ı", "ı", "ɾ", "ɾ",
    "ʞ", "ʞ", "l", "l", "ɯ", "ɯ", "u", "u", "o", "o",
    "d", "d", "b", "b", "ɹ", "ɹ", "s", "s", "ʇ", "ʇ",
    "n", "n", "ʌ", "ʌ", "ʍ", "ʍ", "x", "x", "ʎ", "ʎ",
    "z", "z"
]

struct FlipTextView : View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var inputString : String = ""
    @State private var selectedIndex : Int = 0
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
                
                HStack(spacing: 24) {
                    SelectableButton(
                        title: "level".localized(),
                        isSelected: selectedIndex == 0
                    ) {
                        selectedIndex = 0
                    }
                    SelectableButton(
                        title: "vertical".localized(),
                        isSelected: selectedIndex == 1
                    ) {
                        selectedIndex = 1
                    }
                }
                
                Button(action:{
                    guard !inputString.isEmpty else { return }

                    var newString = ""

                    for char in inputString {
                        let charStr = String(char)
                        if let index = defaultArray.firstIndex(of: charStr),
                           index < fanzhuanArray.count {
                            newString.append(fanzhuanArray[index])
                        } else {
                            newString.append(charStr)
                        }
                    }
                    if selectedIndex == 1 {
                        newString = String(newString.reversed())
                    }
                    createString += newString
                    
                }){
                    CustomText(text: "Generate".localized(),
                               fontName: Constants.FontString.semibold,
                               fontSize: 14,
                               colorHex: "#FFFFFFFF")
                        .frame(maxWidth: 220,maxHeight: 34)
                        .background(Color(hex: "#00B81CFF"))
                        .cornerRadius(10)
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
        .navigationModifiers(title: "Flip text".localized(), onBack: {
            dismiss()
        })
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
    }
}

#Preview {
    FlipTextView()
}
