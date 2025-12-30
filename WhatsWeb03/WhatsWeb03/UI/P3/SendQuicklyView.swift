//
//  Untitled.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/22.
//

import SwiftUI
import Kingfisher

struct SendQuicklyView:View {
    
    @Environment(\.dismiss) var dismiss

    @State private var showFullCountry = false
    @State private var phoneString : String = ""
    @State private var inputString : String = ""
    @State private var selectedCountry = CountryManager.getDefaultCountry()
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                Image("lab_c_icon1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 206,height: 137)
                CustomText(text: "选择国家代码并输入电话号码".localized(), fontName: Constants.FontString.medium
                           , fontSize: 14, colorHex: "#00B81CFF")
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.top,20)
                InputTopView()
                CustomText(text: "发送文本".localized(), fontName: Constants.FontString.medium
                           , fontSize: 14, colorHex: "#00B81CFF")
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.top,16)
                
                BorderedTextEditor(text: $inputString, placeholder: "请输入文本内容".localized())
                    .padding(.top,12)

                VStack(spacing: 20) {
                    CustomButton(
                        title: "发送".localized(),
                        imageName: "lab_c_icon2",
                        titleColor: "#FFFFFFFF",
                        backgroundColor: "#00B81CFF",
                        action: {
                            let code = selectedCountry?.number ?? ""
                            let phoneNumber = phoneString.trimmingCharacters(in: .whitespacesAndNewlines)
                            let content = inputString
                            if phoneNumber.isEmpty {
                                ToastManager.shared.showToast(message: "Please enter your phone number".localized())
                                return
                            }
                            let smsString = "sms:\(code)\(phoneNumber)&body=\(content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                            if let smsURL = URL(string: smsString) {
                                UIApplication.shared.open(smsURL, options: [:], completionHandler: nil)
                            }
                        }
                    )
                    CustomButton(
                        title: "发送".localized(),
                        imageName: "lab_c_icon3",
                        titleColor: "#00B81CFF",
                        backgroundColor: "#E1FFDEFF",
                        action: {
                            // Second button action
                            let code = selectedCountry?.number ?? ""
                            let phoneNumber = phoneString.trimmingCharacters(in: .whitespacesAndNewlines)
                            let content = inputString
                            if phoneNumber.isEmpty {
                                ToastManager.shared.showToast(message: "Please enter your phone number".localized())
                                return
                            }
                            let urlString = "whatsapp://send?phone=\(code)\(phoneNumber)&text=\(content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                            if let whatsappURL = URL(string: urlString) {
                                UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                            }
                        }
                        
                    )
                }
                    .padding(.horizontal,35)
                    .padding(.top,20)
                
                Spacer()
            }
            .padding(.top,20)
            .padding(.horizontal,16)
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
        .navigationModifiers(title: "Quick Send".localized(), onBack: {
            dismiss()
        })
        .sheet(isPresented: $showFullCountry) {
            SelectCountryView(onComplete: { model in
                selectedCountry = model
            })
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

extension SendQuicklyView{
    @ViewBuilder
    private func InputTopView() -> some View{
        VStack(spacing: 12){
            Button(action:{
                showFullCountry.toggle()
            }){
                HStack(spacing:25){
                    
                    KFImage(URL(string: selectedCountry?.logo ?? ""))
                        .placeholder {
                            Color.clear
                                .frame(width: 25, height: 25)
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    CustomText(text: selectedCountry?.name ?? "", fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#101010FF")
                    Spacer()
                    Image("home_arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20,height: 20)
                }
            }
            Divider()
            HStack(spacing:25){
                CustomText(text: selectedCountry?.number ?? "", fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#101010FF")
                TextField("请输入".localized(), text: $phoneString)
                    .foregroundColor(Color(hex: "#101010FF"))
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .padding(.top,12)
    }
    
    private struct CustomButton: View {
        let title: String
        let imageName: String?
        let titleColor: String
        let backgroundColor: String
        var cornerRadius: CGFloat = 20
        var height: CGFloat = 40
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    if let imageName = imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    CustomText(text: title, fontName: Constants.FontString.medium, fontSize: 14, colorHex: titleColor)
                }
                .frame(maxWidth: .infinity, maxHeight: height)
                .background(
                    Color(hex: backgroundColor)
                )
                .cornerRadius(cornerRadius)
            }
        }
    }
}

#Preview {
    SendQuicklyView()
}
