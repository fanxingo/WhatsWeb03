//
//  FeedbackView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/24.
//

import SwiftUI

struct FeedbackView:View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var inputString : String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 16){
                BorderedTextEditor(text: $inputString,
                                   placeholder: "请输入您的反馈信息".localized(),
                                   cornerRadius: 20,
                                   minHeight: 200,
                                   maxHeight: 200)
                .padding(.top,24)
                Spacer()
                
                Button(action:{
                    
                }) {
                    CustomText(text: "提交".localized(),
                               fontName: Constants.FontString.semibold,
                               fontSize: 14,
                               colorHex: "#FFFFFFFF")
                        .frame(maxWidth: 240,maxHeight: 36)
                        .background(Color(hex: "#00B81CFF"))
                        .cornerRadius(20)
                }
                .safeAreaPadding(.bottom)
            }
            .padding(.horizontal,16)
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationModifiers(title: "Feedback".localized(), onBack: {
            dismiss()
        })
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
    }
}

#Preview {
    FeedbackView()
}
