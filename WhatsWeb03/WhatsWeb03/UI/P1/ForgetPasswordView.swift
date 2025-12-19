//
//  ForPassWord.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/18.
//



import SwiftUI
import Combine

class AppLockQuestions: ObservableObject {
    @Published var answers: [String] = Array(repeating: "", count: 3)
    let titles = [
        "你最喜欢的儿时伙伴叫什么名字？".localized(),
        "你最喜欢的电影是什么？".localized(),
        "你最喜欢的食物是什么？".localized()
    ]
}

struct ForgetPasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settings: SettingsManager
    @StateObject private var questionsManager = AppLockQuestions()

    @State private var selectedQuestionIndex: Int = 0
    @State private var showFloatingWindow: Bool = false
    @State private var inputQuestionAnswer: String = ""
    @State private var showError: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading){
            VStack(spacing: 0){
                CustomText(text: "请您回答正确答案".localized(), fontName: Constants.FontString.medium, fontSize: 12, colorHex: "#06C36EFF")
                
                HStack {
                    CustomText(text: questionsManager.titles[selectedQuestionIndex], fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#101010FF")
                    Spacer()
                    Button(action:{
                        withAnimation {
                            showFloatingWindow.toggle()
                        }
                    }){
                        Image(showFloatingWindow ? "applock_down2" : "applock_down1")
                            .scaledToFit()
                    }
                    .frame(width: 44,height: 44)
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
                .padding(.top,34)
                
                HStack {
                    TextField("请填写您的答案".localized(), text: $inputQuestionAnswer)
                        .foregroundColor(Color(hex: "#101010FF"))
                        .font(.custom(Constants.FontString.medium, size: 12))
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
                .padding(.top,16)
                
                if showError {
                    Text("答案错误，请重试".localized())
                        .foregroundColor(.red)
                        .font(.custom(Constants.FontString.medium, size: 12))
                        .padding(.top, 8)
                }
                
                Spacer()
                
                Button(action: {
                    var correctAnswer: String = ""
                    switch selectedQuestionIndex {
                    case 0:
                        correctAnswer = settings.userQuestion1
                    case 1:
                        correctAnswer = settings.userQuestion2
                    case 2:
                        correctAnswer = settings.userQuestion3
                    default:
                        correctAnswer = ""
                    }
                    if inputQuestionAnswer == correctAnswer {
                        settings.userPassword = ""
                        settings.userQuestion1 = ""
                        settings.userQuestion2 = ""
                        settings.userQuestion3 = ""
                        dismiss()
                    } else {
                        inputQuestionAnswer = ""
                        showError = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showError = false
                        }
                    }
                }) {
                    CustomText(text: "确定".localized(),
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
            .padding(.top,32)
            .padding(.horizontal)
            
            if showFloatingWindow {
                self.floatingQuestionSelection(questions: questionsManager.titles, selectedIndex: $selectedQuestionIndex, showFloatingWindow: $showFloatingWindow)
                    .padding(.top,32 + 34 + 44 + 20)
                    .padding(.horizontal, 16)
            }
        }
        .background(
            Color(hex: "#FBFFFCFF")
        )
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
        .navigationModifiers(title: "忘记密码".localized(), onBack: {
            dismiss()
        })
    }
    
}

extension View {
    func floatingQuestionSelection(questions: [String], selectedIndex: Binding<Int>, showFloatingWindow: Binding<Bool>) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<questions.count, id: \.self) { index in
                Button(action: {
                    selectedIndex.wrappedValue = index
                    withAnimation { showFloatingWindow.wrappedValue = false }
                }) {
                    Text(questions[index])
                        .fontWeight(selectedIndex.wrappedValue == index ? .bold : .regular)
                        .foregroundColor(selectedIndex.wrappedValue == index ? Color.black : Color.gray)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
        .zIndex(1)
    }
}

#Preview {
    @Previewable @StateObject var settings = SettingsManager()
    ForgetPasswordView()
        .environmentObject(settings)

}
