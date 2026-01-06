//
//  PayView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//

import SwiftUI

struct PayView : View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var remindMe = false
    
    var body: some View {
        ZStack{
            Image("payview_groundback")
                .resizable()
                .scaledToFill()
            VStack{
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image("nav_back_image")
                            .resizable()
                            .frame(width: 55,height: 55)
                    }
                    Spacer()
                    Button(action:{
                        
                    }){
                        CustomText(text: "recover".localized(), fontName: Constants.FontString.medium, fontSize: 12, colorHex: "#101010FF")
                    }
                }
                ZStack{
                    Image("payview_icon1")
                        .resizable()
                        .scaledToFit()
                    GradientText(
                        text: "Unlock all Features".localized(),
                        colors: [Color(hex: "#00D125FF"), Color(hex: "#09AEFDFF")],
                        font: .custom(Constants.FontString.semibold, size: 20),
                        starPoint: .top,
                        endPoint: .bottom
                    )
                    .padding(.horizontal,30)
                }
                .frame(width: 234,height: 70)
                .padding(.top,20)
                
                let names = ["Dual Messengers, Seamless Switching".localized(),
                             "Message Backup".localized(),
                             "Privacy protection".localized(),
                             "Unlimited translation text".localized(),
                             "Unlock all features".localized()]

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(names, id: \.self) { name in
                        HStack{
                            Image("tips_icon10")
                                .resizable()
                                .frame(width: 24,height: 24)
                            CustomText(text: name, fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#101010FF")
                        }
                    }
                }
                .padding(.top,25)
                
                HStack{
                    Toggle(isOn: $remindMe) {
                        CustomText(text: "3-Day Free Trial Activation".localized(), fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#121212FF")
                    }
                    .tint(Color(hex: "#00B81CFF"))
                }
                .padding(.vertical,4)
                .padding(.horizontal,16)
                .frame(maxWidth: .infinity)
                .background(
                    Color(hex: "#FFFFFFFF")
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "#F1F1F1FF"), lineWidth: 2)
                )
                .cornerRadius(20)
                .padding(.top,30)
                
                
                HStack{
                    Image("payview_icon2")
                        .scaledToFit()
                    VStack(spacing:16){
                        HStack{
                            CustomText(text: "Starting today".localized(), fontName: Constants.FontString.semibold, fontSize: 14, colorHex: "#00B81CFF")
                            Spacer()
                            CustomText(text: "3 days free %@".localized("HK$0"), fontName: Constants.FontString.semibold, fontSize: 14, colorHex: "#00B81CFF")
                        }
                        HStack{
                            CustomText(text: "Expires on March 14, 2025", fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#121212FF")
                            Spacer()
                            CustomText(text: "HK$88", fontName: Constants.FontString.semibold, fontSize: 14, colorHex: "#121212FF")
                        }
                    }
                }
                .padding(.horizontal,12)
                .padding(.top,12)
                
                ZStack(alignment: .topTrailing){
                    HStack{
                        VStack(alignment: .leading){
                            CustomText(text: "Year".localized(), fontName: Constants.FontString.semibold, fontSize: 16, colorHex: "#00B81CFF")
                            CustomText(text: "%@/Week".localized("HK$20"), fontName: Constants.FontString.semibold, fontSize: 12, colorHex: "#00B81CFF")
                        }
                        Spacer()
                        CustomText(text: "%@/Year".localized("HK$488"), fontName: Constants.FontString.semibold, fontSize: 16, colorHex: "#00B81CFF")
                    }
                    .padding(.vertical,8)
                    .padding(.horizontal,16)
                    .background(
                        Color(hex: "#D1FFD9FF")
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "#00B81CFF"), lineWidth: 2)
                    )
                    .frame(maxWidth: .infinity)
                    .cornerRadius(20)
                    .padding(.top,14)
                    
                    CustomText(text: "Best Choice".localized(), fontName: Constants.FontString.medium, fontSize: 12, colorHex: "#FFFFFFFF")
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .background(
                            LinearGradient(colors: [Color(hex: "#FD6952FF"),
                                                    Color(hex: "#FF9000FF")], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(20)
                }
                
                HStack{
                    CustomText(text: "Week".localized(), fontName: Constants.FontString.semibold, fontSize: 16, colorHex: "#101010FF")
                    Spacer()
                    CustomText(text: "HK$20".localized(), fontName: Constants.FontString.semibold, fontSize: 16, colorHex: "#AEAEAEFF")
                }
                .padding(.vertical,6)
                .padding(.horizontal,16)
                .background(
                    Color(hex: "#FFFFFFCC")
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "#F1F1F1FF"), lineWidth: 2)
                )
                .frame(maxWidth: .infinity)
                .cornerRadius(20)

                Spacer()
                CustomText(text: "Free trial for 3 days, then %@ per week".localized("$9.9"), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#444444FF")
                Button(action:{
                    
                }){
                    CustomText(
                        text: "Free trial".localized(),
                        fontName: Constants.FontString.semibold,
                        fontSize: 20,
                        colorHex: "#FFFFFFFF"
                    )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(
                            Color(hex: "#00B81CFF")
                        )
                        .cornerRadius(20)
                }
                .padding(.top,5)
                
                AgreementText()
                    .environment(\.openURL, OpenURLAction { url in
                        switch url.absoluteString {
                        case "app://userAgreement":
                            UIApplication.shared.open(URL(string: "https://www.baidu.com")!)
                            return .handled
                        case "app://privacyPolicy":
                            UIApplication.shared.open(URL(string: "https://www.baidu.com")!)
                            return .handled
                        default:
                            return .systemAction
                        }
                    })
                    .padding(.bottom,safeBottom)
                    .padding(.top,5)
            }
            .padding(.top,safeTop)
            .padding(.horizontal,16)
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    PayView()
}
