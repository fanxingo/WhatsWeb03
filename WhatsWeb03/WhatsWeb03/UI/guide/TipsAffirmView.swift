//
//  Tips.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//

import SwiftUI
import StoreKit


struct TipsAffirmView : View {
    
    var onComplete: () -> Void
    
    @EnvironmentObject var settings: SettingsManager
    @StateObject private var productStore = SubscriptionProductStore.shared
    @StateObject private var payManager = PayManager.shared
    
    
    @State private var remindMe = false
    @State private var showCloseButton = false
    
    @State private var product: Product?

    var priceText: AttributedString {
        let price = product?.displayPrice ?? "$9.99"
        let rawString = "Dual Chat, message backup, privacy protection, unlimited text translation, and more. 3-day free trial, then %@/week, cancel anytime.".localized(price)
        var attrStr = AttributedString(rawString)
        attrStr.font = .custom(Constants.FontString.medium, size: 14)
        attrStr.foregroundColor = Color(hex: "#7D7D7DFF")

        if let range = attrStr.range(of: price) {
            attrStr[range].foregroundColor = Color(hex: "#00B81CFF")
        }
        return attrStr
    }

    var body: some View {
        ZStack{
            VStack() {
                ScrollView {
                    VStack(alignment: .center, spacing: 0){
                        Image("tips_icon1")
                            .resizable()
                            .frame(width: 274,height: 181)
                            .padding(.top,26)
                        CustomText(
                            text: "Questions?".localized(),
                            fontName: Constants.FontString.semibold,
                            fontSize: 20,
                            colorHex: "#00B81CFF")
                        .padding(.top,8)
                        .padding(.horizontal,16)
                        
                        Text(priceText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.top, 10)
            
                        HStack{
                            Image("tips_icon2")
                                .resizable()
                                .frame(width: 54,height: 54)
                            VStack(alignment: .leading,spacing: 4){
                                CustomText(text: "You can unsubscribe at any time.".localized(),
                                           fontName: Constants.FontString.semibold,
                                           fontSize: 16,
                                           colorHex: "#101010FF")
                                CustomText(text: "No payment required now".localized(),
                                           fontName: Constants.FontString.medium,
                                           fontSize: 14,
                                           colorHex: "#00B81CFF")
                            }
                            Spacer()
                        }
                        .padding(16)
                        .background(
                            Image("tips_icon3")
                                .resizable(capInsets: EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20), resizingMode: .stretch)
                        )
                        .padding(.top,16)
                        .padding(.horizontal,16)
                        
                        CustomText(text: "How your free trial works".localized(),
                                   fontName: Constants.FontString.semibold,
                                   fontSize: 20,
                                   colorHex: "#00B81CFF")
                            .padding(.top,16)
                            .padding(.horizontal,16)
                        
                        HStack(spacing: 12){
                            ZStack{
                                Image("tips_icon6")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20)
                                VStack{
                                    Image("tips_icon7")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16,height: 16)
                                        .padding(.top,16)
                                    Image("tips_icon8")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16,height: 16)
                                        .padding(.top,40)
                                    Image("tips_icon9")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16,height: 16)
                                        .padding(.top,80)
                                    Spacer()
                                }
                            }
                            VStack(alignment: .leading){
                                CustomText(text: "today".localized(),
                                           fontName: Constants.FontString.semibold,
                                           fontSize: 14,
                                           colorHex: "#101010FF")
                                    .padding(.top,14)
                                CustomText(text: "Unlock all features for free".localized(),
                                           fontName: Constants.FontString.medium,
                                           fontSize: 14,
                                           colorHex: "#7D7D7DFF")
                                
                                CustomText(text: "Day 2: Reminder".localized(),
                                           fontName: Constants.FontString.semibold,
                                           fontSize: 14,
                                           colorHex: "#101010FF")
                                    .padding(.top,14)
                                CustomText(text: "Please give us a 1-day advance notice and cancel at any time to avoid charges.".localized(),
                                           fontName: Constants.FontString.medium,
                                           fontSize: 14,
                                           colorHex: "#7D7D7DFF")
                                
                                RemindButton(remindMe:$remindMe)
                                
                                CustomText(text: "Day 3: Trial ends".localized(),
                                           fontName: Constants.FontString.semibold,
                                           fontSize: 14,
                                           colorHex: "#101010FF")
                                    .padding(.top,14)
                                CustomText(text: "Your subscription will begin after a 3-day trial, which you can cancel at any time before then.".localized(),
                                           fontName: Constants.FontString.medium,
                                           fontSize: 14, colorHex: "#7D7D7DFF")
                            }
                            Spacer()
                        }
                        .padding(.horizontal,40)
                        .padding(.top,16)
                        
                        VStack(alignment: .leading,spacing: 12){
                            CustomText(text: "How to cancel?".localized(),
                                       fontName: Constants.FontString.semibold,
                                       fontSize: 14,
                                       colorHex: "#101010FF")
                            CustomText(text: "Open your phone's Settings > Apple, then select \"Subscriptions\". Select the app, tap \"Cancel Subscription\", and confirm.".localized(),
                                       fontName: Constants.FontString.medium,
                                       fontSize: 14,
                                       colorHex: "#7D7D7DFF")
                            HStack{
                                Spacer()
                                CustomText(text: "Money-back guarantee".localized(), fontName: Constants.FontString.medium, fontSize: 12, colorHex: "#FFB12BFF")
                                Spacer()
                                
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(
                            Image("tips_icon3")
                                .resizable(capInsets: EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20), resizingMode: .stretch)
                        )
                        .padding(.horizontal,16)
                        .padding(.top,20)
                        
                        CustomText(text: "What will you get?".localized(),
                                   fontName: Constants.FontString.semibold,
                                   fontSize: 20,
                                   colorHex: "#00B81CFF")
                            .padding(.top,16)
                            .padding(.horizontal,16)
                        
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
                        .padding(.top,16)


                        HStack(spacing:0){
                            CustomText(text: "terms".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#838383FF")
                                .underline()
                                .onTapGesture {
                                    UIApplication.shared.open(URL(string: "https://sites.google.com/view/dual-chat-terms-of-service")!)
                                }
                            CustomText(text: "&", fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#838383FF")
                            CustomText(text: "privacy".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#838383FF")
                                .underline()
                                .onTapGesture {
                                    UIApplication.shared.open(URL(string: "https://sites.google.com/view/dual-chat-privacy-policy")!)
                                }
                            Spacer()
                            if showCloseButton{
                                CustomText(text: "Limited Edition".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#838383FF")
                                    .underline()
                                    .onTapGesture {
                                        onComplete()
                                    }
                            }
                            Spacer()
                            CustomText(text: "recover".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#838383FF")
                                .underline()
                                .onTapGesture {
                                    LoadingMaskManager.shared.show()
                                    Task {
                                        // 10 秒后自动隐藏
                                        Task {
                                            try? await Task.sleep(nanoseconds: 10 * 1_000_000_000) // 10秒
                                            LoadingMaskManager.shared.hide()
                                        }
                                        await payManager.restore()
                                    }
                                }
                        }
                        .padding(24)
        
                        
                    }
                }
                .scrollIndicators(.hidden)
                BottomView(remindMe: $remindMe, onComplete: {
                    LoadingMaskManager.shared.show()
                    Task {
                        // 10 秒后自动隐藏
                        Task {
                            try? await Task.sleep(nanoseconds: 10 * 1_000_000_000) // 10秒
                            LoadingMaskManager.shared.hide()
                        }

                        // 执行购买
                        if let id = product?.id {
                            await payManager.purchase(productId: "\(id)")
                        }
                    }
                })
            }
            .id(remindMe)
        }
        .fullScreenBackground("loding_bgimage",true)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                showCloseButton = true
            }
        }
        .onReceive(payManager.$purchaseSuccess) { success in
            if let success = success {
                print("购买成功：\(success.productId)")
                
                AnalyticsManager.saveBurialPoint(eventName: "first_sub_success", check: true)
                
                if let product = product {
                    if "\(product.id)" == "whats04_3dsub_week1" {
                        AnalyticsManager.saveBurialPoint(eventName: "sub_sec_success", check: false)
                    }
                }
                
                settings.hasWhatsPayStatus = true
                LoadingMaskManager.shared.hide()
                onComplete()
            }
        }
        .onReceive(payManager.$purchaseError) { error in
            if error != nil {
                LoadingMaskManager.shared.hide()
            }
        }
        .task {
            let hasTrial = await hasIntroTrial(productID: "whats04_3dsub_week2")
            let productId = hasTrial
                ? "whats04_3dsub_week2"
                : "whats04_3dsub_week1"

            product = productStore.product(for: productId)
        }
    }
}

extension TipsAffirmView{
    private struct RemindButton: View{
        @Binding var remindMe: Bool
        var body: some View{
            Button(action:{
                if !remindMe{
                    remindMe = true
                }
            }){
                ZStack{
                    CustomText(text: remindMe ? "You will receive a notification".localized() : "Remind me".localized(),
                               fontName: Constants.FontString.medium,
                               fontSize: 12,
                               colorHex: "#00B81CFF")
                }
                .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                .background(
                    Image("tips_icon5")
                        .resizable(capInsets: EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12), resizingMode: .stretch)
                )
            }
        }
    }
    private struct BottomView: View {
            @Binding var remindMe: Bool
            var onComplete: () -> Void
            
            var body: some View {
                VStack(spacing: 0) {
                    HStack(spacing:12){
                        Image("guide_icon1")
                            .resizable()
                            .frame(width: 20,height: 20)
                        CustomText(
                            text: "Don't worry, you'll be reminded before it expires.".localized(),
                            fontName: Constants.FontString.medium,
                            fontSize: 12, colorHex: "#424242FF")
         
                        Toggle("", isOn: $remindMe)
                            .labelsHidden()
                            .toggleStyle(.switch)
                            .padding(.trailing)
                            .tint(Color(hex: "#00B81CFF"))
                    }
                    .frame(height: 50)
                    .padding(.horizontal,16)
                    .background(Color(hex: "#FFFFFFFF"))
                    .cornerRadius(25)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    Button(action: {
                        onComplete()
                    }) {
                        CustomText(
                            text: "Free trial".localized(),
                            fontName: Constants.FontString.semibold,
                            fontSize: 20,
                            colorHex: "#FFFFFFFF"
                        )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#30DA4EFF"),
                                        Color(hex: "#01B91FFF")
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(25)
                    }
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: safeBottom + 16, trailing: 16))
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color(hex: "#DFEEF0FF"),
                            Color(hex: "#FFFFFFFF")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(
                    RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                )
            }
        }
}
