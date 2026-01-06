//
//  RepeatingTextView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/23.
//

import SwiftUI

struct RepeatingTextView : View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var inputString : String = ""
    @State private var inputRepe: String = "1"
    @State private var selectedIndex: Int = 0
    @State private var createString : String = ""
    var body: some View {
        ZStack {
            VStack(spacing: 16){
                BorderedTextEditor(text: $inputString,
                                   placeholder: "Please enter text content.".localized(),
                                   cornerRadius: 20,
                                   minHeight: 100,
                                   maxHeight: 100)
                .padding(.top,12)
                
                HStack(spacing:16){
                    CustomText(text: "Number of repetitions".localized(),
                               fontName: Constants.FontString.medium,
                               fontSize: 14,
                               colorHex: "#000000FF")
                    TextField("", text: $inputRepe)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(width: 65, height: 35)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#DCDCDCFF"), lineWidth: 1)
                        )
                    Spacer()
                    
                    Button(action:{
                        let count = Int(inputRepe) ?? 0
                        guard count > 0, !inputString.isEmpty else {
                            return
                        }
                        
                        let generated: String
                        if selectedIndex == 0 {
                            // 水平：直接拼接
                            generated = String(repeating: inputString, count: count)
                        } else {
                            // 垂直：每次换行
                            generated = Array(repeating: inputString, count: count)
                                .joined(separator: "\n")
                        }
                        
                        if createString.isEmpty {
                            createString = generated
                        } else {
                            // 追加，垂直时自动换行
                            createString += selectedIndex == 1 ? "\n" + generated : generated
                        }
                    }){
                        CustomText(text: "generate".localized(),
                                   fontName: Constants.FontString.semibold,
                                   fontSize: 14,
                                   colorHex: "#FFFFFFFF")
                        .frame(maxWidth: 120,maxHeight: 34)
                        .background(Color(hex: "#00B81CFF"))
                        .cornerRadius(10)
                    }
                }
                
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
                VStack(spacing: 0){
                    HStack{
                        CustomText(text: "Result".localized(), fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#101010FF")
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
        .navigationModifiers(title: "RepeatingText".localized(), onBack: {
            dismiss()
        })
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
    }
}

struct SelectableButton: View {
    
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom(Constants.FontString.medium, size: 14))
                .foregroundColor(
                    isSelected
                    ? Color(hex: "#00B81CFF")
                    : Color(hex: "#7D7D7DFF")
                )
                .frame(maxWidth: .infinity, minHeight: 34)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            isSelected
                            ? Color(hex: "#00B81CFF")
                            : Color(hex: "#DCDCDCFF"),
                            lineWidth: 1
                        )
                )
        }
    }
}
