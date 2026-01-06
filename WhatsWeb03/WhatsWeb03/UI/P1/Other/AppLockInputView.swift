//
//  AppLockInputView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/16.
//

import SwiftUI

enum AppLockAction {
    case success
    case forgetPassword
    case cancel
}

struct AppLockInputView : View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settings: SettingsManager
    
    
    var onAction: (AppLockAction) -> Void
    
    @State private var inputCount : Int = 3
    @State private var inputText: String = ""
    @State private var disableKeyboard: Bool = false
    
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image("nav_back_image")
                            .resizable()
                            .frame(width: 55,height: 55)
                    }
                    Spacer()
                }
                .padding(.horizontal,16)
                
                VStack(spacing: 8) {
                    
                    CustomText(text: disableKeyboard ? "Incorrect password".localized() : "Enter password".localized(),
                               fontName: Constants.FontString.semibold,
                               fontSize: 16, colorHex: disableKeyboard ? "#FF0000FF" : "#101010FF")
                    
                    ZStack {
                        if inputCount <= 0 {
                            CustomText(text: "forget the password?".localized(), fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#147D0DFF")
                                .underline()
                                .onTapGesture {
                                    onAction(.forgetPassword)
                                }
                        } else {
                            Color.clear
                        }
                    }
                    .padding(.top, 40)
                    .frame(height: 14)
                }
                .padding(.top,50)
                

                HStack(spacing: 0) {
                    ForEach(0..<4, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "#EDEDEDFF"))
                                .frame(width: 60, height: 60)

                            if index < inputText.count {
                                Circle()
                                    .fill(Color(hex: "#101010FF"))
                                    .frame(width: 10, height: 10)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 50)
                

                Spacer()
                NumericKeyboardView(onKeyTap: handleKeyTap, disableKeys: disableKeyboard)
                    .padding(.bottom,safeBottom)
            }
            .padding(.top,safeTop)
        }
        .ignoresSafeArea(.all)
        .background(
            Color(hex: "#FBFFFCFF")
        )
    }
}

extension AppLockInputView{
    private func handleKeyTap(_ key: String) {
        if disableKeyboard {
            return
        }
        if key == "⌫" {
            if !inputText.isEmpty {
                inputText.removeLast()
            }
        } else {
            if inputText.count < 4 {
                inputText.append(key)
            }

            if inputText.count == 4 {
                if inputText == settings.userPassword {
                    onAction(.success)
                } else {
                    disableKeyboard = true
                    inputCount -= 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        inputText = ""
                        disableKeyboard = false
                    }
                }
            }
        }
    }
}
