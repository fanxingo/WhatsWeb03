//
//  PayView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//

import SwiftUI
import StoreKit

struct PayView : View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var settings: SettingsManager
    
    @State private var freeStatus = false
    
    
    @State private var yearProduct: Product?
    @State private var weekProduct: Product?
    
    @State private var currentProduct: Product?
    
    @StateObject private var productStore = SubscriptionProductStore.shared
    @StateObject private var payManager = PayManager.shared
    
    var weekPriceText: String {
        guard let yearProduct = yearProduct else { return "$0.0" }

        // 获取年价格数值
        let priceDecimal = yearProduct.price  // StoreKit 2 的 Decimal 类型
        let yearPriceDouble = NSDecimalNumber(decimal: priceDecimal).doubleValue

        // 一年按 52 周
        let weekPrice = yearPriceDouble / 52

        // 保留 1 位小数
        let formattedWeekPrice = String(format: "%.1f", weekPrice)

        // 获取年价格的货币符号
        let currencySymbol = yearProduct.priceFormatStyle.locale.currencySymbol ?? "$"

        return "\(currencySymbol)\(formattedWeekPrice)"
    }
    
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
                        LoadingMaskManager.shared.show()
                        Task {
                            // 10 秒后自动隐藏
                            Task {
                                try? await Task.sleep(nanoseconds: 10 * 1_000_000_000) // 10秒
                                LoadingMaskManager.shared.hide()
                            }
                            await payManager.restore()
                        }
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
                    Toggle(isOn: $freeStatus) {
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
                
                if freeStatus {
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
                                CustomText(text: currentProduct?.displayPrice ?? "", fontName: Constants.FontString.semibold, fontSize: 14, colorHex: "#121212FF")
                            }
                        }
                    }
                    .padding(.horizontal,12)
                    .padding(.top,12)
                }

                Button(action: {
                    currentProduct = yearProduct
                }) {
                    ZStack(alignment: .topTrailing) {
                        HStack {
                            VStack(alignment: .leading){
                                CustomText(text: "Year".localized(), fontName: Constants.FontString.semibold, fontSize: 16, colorHex: "#00B81CFF")
                                CustomText(text: "%@/Week".localized(weekPriceText), fontName: Constants.FontString.semibold, fontSize: 12, colorHex: "#00B81CFF")
                            }
                            Spacer()
                            CustomText(text: "%@/Year".localized(yearProduct?.displayPrice ?? ""), fontName: Constants.FontString.semibold, fontSize: 16, colorHex: "#00B81CFF")
                        }
                        .padding(.vertical,8)
                        .padding(.horizontal,16)
                        .background(currentProduct?.id == yearProduct?.id ? Color(hex: "#D1FFD9FF") : Color(hex: "#FFFFFF"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "#00B81CFF"), lineWidth: currentProduct?.id == yearProduct?.id ? 2 : 1)
                        )
                        .cornerRadius(20)
                        .padding(.top,14)
                        
                        if currentProduct?.id == yearProduct?.id {
                            CustomText(text: "Best Choice".localized(), fontName: Constants.FontString.medium, fontSize: 12, colorHex: "#FFFFFFFF")
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                .background(
                                    LinearGradient(colors: [Color(hex: "#FD6952FF"),
                                                            Color(hex: "#FF9000FF")], startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(20)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle()) // 避免系统按钮样式干扰
                
                // Week 选项
                Button(action: {
                    currentProduct = weekProduct
                }) {
                    HStack{
                        CustomText(text: "Week".localized(), fontName: Constants.FontString.semibold, fontSize: 16, colorHex: "#101010FF")
                        Spacer()
                        CustomText(text: weekProduct?.displayPrice ?? "", fontName: Constants.FontString.semibold, fontSize: 16, colorHex: "#AEAEAEFF")
                    }
                    .padding(.vertical,6)
                    .padding(.horizontal,16)
                    .background(currentProduct?.id == weekProduct?.id ? Color(hex: "#D1FFD9FF") : Color(hex: "#FFFFFFCC"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(currentProduct?.id == weekProduct?.id ? Color(hex: "#00B81CFF") : Color(hex: "#F1F1F1FF"), lineWidth: currentProduct?.id == weekProduct?.id ? 2 : 1)
                    )
                    .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
                if freeStatus {
                    CustomText(text: "Free trial for 3 days, then %@ per week".localized(currentProduct?.displayPrice ?? ""), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#444444FF")
                }
                Button(action:{
                    LoadingMaskManager.shared.show()
                    Task {
                        // 10 秒后自动隐藏
                        Task {
                            try? await Task.sleep(nanoseconds: 10 * 1_000_000_000) // 10秒
                            LoadingMaskManager.shared.hide()
                        }

                        // 执行购买
                        if let id = currentProduct?.id {
                            await payManager.purchase(productId: "\(id)")
                        }
                    }
                }){
                    CustomText(
                        text: freeStatus ? "Free trial".localized() : "Sure".localized(),
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
                            UIApplication.shared.open(URL(string: "https://sites.google.com/view/dual-chat-terms-of-service")!)
                            return .handled
                        case "app://privacyPolicy":
                            UIApplication.shared.open(URL(string: "https://sites.google.com/view/dual-chat-privacy-policy")!)
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
        .loadingMask()
        .onReceive(payManager.$purchaseSuccess) { success in
            if let success = success {
                
                print("购买成功：\(success.productId)")
                AnalyticsManager.saveBurialPoint(eventName: "first_sub_success", check: true)

                //修改支付结果
                settings.hasWhatsPayStatus = true
                LoadingMaskManager.shared.hide()
                dismiss()
            }
        }
        .onReceive(payManager.$purchaseError) { error in
            if error != nil {
                LoadingMaskManager.shared.hide()
            }
        }
        .onChange(of: freeStatus) {oldValue, newValue in
            if newValue {
                yearProduct = productStore.product(for: "whats04_3dsub_year1")
                weekProduct = productStore.product(for: "whats04_3dsub_week1")
            } else {
                yearProduct = productStore.product(for: "whats04_sub_year1")
                weekProduct = productStore.product(for: "whats04_sub_week1")
            }
            currentProduct = yearProduct
        }
        .onAppear{
            yearProduct = productStore.product(for: "whats04_sub_year1")
            weekProduct = productStore.product(for: "whats04_sub_week1")
            currentProduct = yearProduct
        }
    }
}
