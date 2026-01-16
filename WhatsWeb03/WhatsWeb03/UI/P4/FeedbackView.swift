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
                                   placeholder: "Please enter your feedback information.".localized(),
                                   cornerRadius: 20,
                                   minHeight: 200,
                                   maxHeight: 200)
                .padding(.top,24)
                Spacer()
                
                Button(action:{
                    submitFeedback()
                }) {
                    CustomText(text: "submit".localized(),
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
    
    
    private func submitFeedback() {
        
        guard !inputString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            
            ToastManager.shared.showToast(message: "Please enter your question or suggestion here".localized())
            
            return
        }
        
        guard canPerformAction(withKey: "FxFeedbackVC") else {
            
            ToastManager.shared.showToast(message: "Commit too often, try again later!".localized())
            
            return
        }
        
        let params = [
            "uid": UUIDTool.getUUIDInKeychain(),
            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown",
            "question": inputString
        ]
        
        LoadingMaskManager.shared.show()
        
        let urlString = BaseUrl("/a/feedback")
        
        NetworkManager.shared.sendPOST2Request(urlString: urlString, parameters: params) { result in
            DispatchQueue.main.async {
                
                LoadingMaskManager.shared.hide()
                
                switch result {
                case .success(_):
                    
                    ToastManager.shared.showToast(message:"Submit Success!".localized())
                    dismiss()
                    
                case .failure(_): break
                    
                }
            }
        }
        
        func canPerformAction(withKey key: String) -> Bool {
            let currentDate = Date()
            if let lastDate = UserDefaults.standard.object(forKey: key) as? Date {
                let timeInterval = currentDate.timeIntervalSince(lastDate)
                if timeInterval < 60 {
                    return false
                }
            }
            UserDefaults.standard.set(currentDate, forKey: key)
            return true
        }
    }
}
