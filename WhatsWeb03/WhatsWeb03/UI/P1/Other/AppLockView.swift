//
//  AppLockView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/16.
//

import SwiftUI


struct AppLockView:View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var settings: SettingsManager

    @State private var showFirstView: Bool = true
    @State private var showQuestionView: Bool = false
    
    @State private var showInputLockView = false
    
    @State private var inputText: String = ""
    @State private var disableKeyboard: Bool = false
    
    @State private var firstPassword: String = ""
    @State private var isSecondEntry: Bool = false
    
    @StateObject var questionsManager = AppLockQuestions()
    
    var body: some View {
        ZStack{
            if showFirstView{
                MaskView()
            }else{
                if showQuestionView {
                    CreateQuestionView()
                }else{
                    CreatePasswordView()
                }
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(
            Color(hex: "#FBFFFCFF")
        )
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
        .navigationModifiersWithRightButton(title: "App Lock".localized(),
                                            onBack:{dismiss()},
                                            rightButtonImage: "nav_question_image") {
            navManager.path.append(AppRoute.appLockTutorialView)
        }
        .fullScreenCover(isPresented: $showInputLockView) {
            AppLockInputView { action in
                switch action {
                case .forgetPassword:
                    showInputLockView = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                        navManager.path.append(AppRoute.forgetPasswordView)
                    }
                case .success:
                    
                    settings.userPassword = ""
                    settings.userQuestion1 = ""
                    settings.userQuestion2 = ""
                    settings.userQuestion3 = ""
                    
                    showInputLockView = false
                    
                    showFirstView = true
                case .cancel:
                    showInputLockView = false
                }
            }
        }
    }
}
extension AppLockView{

    private func MaskView() -> some View{
        VStack(spacing:10){
            Image("applock_icon1")
                .frame(width: 149,height: 149)
            CustomText(text: "App Lock".localized(),
                       fontName: Constants.FontString.semibold,
                       fontSize: 18,
                       colorHex: "#101010FF")
            CustomText(text: "One-Click Lock, No Worries About Privacy".localized(),
                       fontName: Constants.FontString.medium,
                       fontSize: 16,
                       colorHex: "#7D7D7DFF")
                .multilineTextAlignment(.center)
            
            Button(action:{
                if settings.hasPassword {
                    showInputLockView = true
                }else{
                    showFirstView = false
                }
            }){
                CustomText(text: settings.hasPassword ? "Disable Password".localized() : "Use Password".localized(),
                           fontName: Constants.FontString.semibold,
                           fontSize: 16,
                           colorHex: settings.hasPassword ? "#101010FF" : "#FFFFFFFF")
                    .padding(EdgeInsets(top: 16, leading: 46, bottom: 16, trailing: 46))
                    .background(
                        settings.hasPassword ? Color(hex: "#E8E8E8FF") : Color(hex: "#00B81CFF")
                    )
                    .cornerRadius(30)
            }
            .padding(.top,20)
            
            Spacer()
        }
        .padding(.horizontal,80)
        .padding(.top,160)
    }
    
    private func CreatePasswordView() -> some View{
        VStack(spacing: 0){
            if disableKeyboard {
                CustomText(text: "The two passwords do not match".localized(),
                           fontName: Constants.FontString.semibold,
                           fontSize: 16,
                           colorHex: "#FF0000FF")
                CustomText(text: "Please re-enter.".localized(),
                           fontName: Constants.FontString.medium,
                           fontSize: 14,
                           colorHex: "#7D7D7DFF")
                    .padding(.top,15)
            } else {
                CustomText(text: isSecondEntry ? "Please enter your password again.".localized() : "Create a password".localized(),
                           fontName: Constants.FontString.semibold,
                           fontSize: 16,
                           colorHex: "#101010FF")
                CustomText(text: "Please enter a 4-digit security password.".localized(),
                           fontName: Constants.FontString.medium,
                           fontSize: 14,
                           colorHex: "#7D7D7DFF")
                    .padding(.top,15)
            }
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
        .padding(.top,125)
    }
    
    private func CreateQuestionView() -> some View{
        VStack(spacing: 16){
            CustomText(text: "Set security questions".localized(),
                       fontName: Constants.FontString.semibold,
                       fontSize: 16,
                       colorHex: "#101010FF")
                .padding(.top,34)
            CustomText(text: "Please set up security questions so you can retrieve your password if you forget it.".localized(),
                       fontName: Constants.FontString.medium,
                       fontSize: 12,
                       colorHex: "#00B81CFF")
            .multilineTextAlignment(.center)
            
            ForEach(questionsManager.titles.indices, id: \.self) { index in
                questionTitle(title: questionsManager.titles[index])
                    .padding(.top, index == 0 ? 0 : 4)
                answerInputView(placeholder: "Please fill in your answer.".localized(), text: $questionsManager.answers[index])
            }

            Spacer()

            Button(action: {
                guard !firstPassword.isEmpty,
                      !questionsManager.answers.contains(where: { $0.isEmpty }) else {
                    return
                }
                
                settings.userPassword = firstPassword
                settings.userQuestion1 = questionsManager.answers[0]
                settings.userQuestion2 = questionsManager.answers[1]
                settings.userQuestion3 = questionsManager.answers[2]
                
                showFirstView = true
                
            }) {
                CustomText(text: "Sure".localized(),
                           fontName: Constants.FontString.semibold,
                           fontSize: 14,
                           colorHex: "#FFFFFFFF")
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background(Color(hex: "#00B81CFF"))
                    .cornerRadius(30)
            }
            .frame(width: 220,height: 40)
            .padding(.bottom,safeBottom + 40)
        }
        .padding(.horizontal,16)
        .frame(maxWidth: .infinity)
    }
    
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
                if !isSecondEntry {
                    firstPassword = inputText
                    inputText = ""
                    isSecondEntry = true
                } else {
                    if inputText == firstPassword {
                        showQuestionView = true
                    } else {
                        disableKeyboard = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            inputText = ""
                            isSecondEntry = false
                            disableKeyboard = false
                            firstPassword = ""
                        }
                    }
                }
            }
        }
    }
}

public func questionTitle(title: String) -> some View{
    HStack{
        CustomText(text: title,
                   fontName: Constants.FontString.medium,
                   fontSize: 14, colorHex: "#101010FF")
        Spacer()
    }
}
public func answerInputView(placeholder: String, text: Binding<String>) -> some View {
    HStack {
        TextField(placeholder.localized(), text: text)
            .foregroundColor(Color(hex: "#101010FF"))
            .font(.custom(Constants.FontString.medium, size: 14))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .frame(maxWidth: .infinity, maxHeight: 44)
    .padding(.horizontal, 16)
    .background(
        RoundedRectangle(cornerRadius: 22)
            .fill(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color(hex: "#F1F1F1FF"), lineWidth: 1)
            )
    )
}

