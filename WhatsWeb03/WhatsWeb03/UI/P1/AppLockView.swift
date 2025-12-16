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
    
    @State private var firstOpen: Bool = true
    @State private var isOpenLock: Bool = true
    
    @State private var showInputLockView = false
    
    var body: some View {
        ZStack{
            if firstOpen{
                MaskView()
            }else{
                
            }
        }
        .background(
            Color(hex: "#FBFFFCFF")
        )
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .dismissKeyboardOnTap()
        .navigationModifiersWithRightButton(title: "Message Backup".localized(), onBack: {
            dismiss()
        }, rightButtonImage: "nav_question_image") {
            navManager.path.append(AppRoute.appLockTutorialView)
        }
        .fullScreenCover(isPresented: $showInputLockView) {
            AppLockInputView()
        }
    }
}
extension AppLockView{
    @ViewBuilder
    private func MaskView() -> some View{
        VStack(spacing:10){
            Image("applock_icon1")
                .frame(width: 149,height: 149)
            CustomText(text: "App Lock".localized(), fontName: Constants.FontString.semibold, fontSize: 18, colorHex: "#101010FF")
            CustomText(text: "One-Click Lock, No Worries About Privacy", fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#7D7D7DFF")
                .multilineTextAlignment(.center)
            
            Button(action:{
                if isOpenLock{
                    showInputLockView = true
                }else{
                    firstOpen = false
                }
            }){
                CustomText(text: isOpenLock ? "Disable Password".localized() : "Use Password".localized(),
                           fontName: Constants.FontString.semibold,
                           fontSize: 16,
                           colorHex: isOpenLock ? "#101010FF" : "#FFFFFFFF")
                    .padding(EdgeInsets(top: 16, leading: 46, bottom: 16, trailing: 46))
                    .background(
                        isOpenLock ? Color(hex: "#E8E8E8FF") : Color(hex: "#00B81CFF")
                    )
                    .cornerRadius(30)
            }
            .padding(.top,20)
            
            Spacer()
        }
        .padding(.horizontal,80)
        .padding(.top,160)
    }
}
#Preview {
    AppLockView()
}
