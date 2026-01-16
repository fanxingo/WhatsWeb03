//
//  GuideView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import SwiftUI
import Combine
import StoreKit


struct GuideItem {
    let image: String
    let title: String
    let subtitleTemplate: String
}

struct GuideView: View {
    
    var onComplete: () -> Void
    var onPayCancelComplete:() -> Void
    
    @EnvironmentObject var settings: SettingsManager
    
    @State private var currentPage = 0
    
    @State var currentIndex = 0
    @State private var isOn: Bool = false
    
    @StateObject private var productStore = SubscriptionProductStore.shared
    @StateObject private var payManager = PayManager.shared
    
    @State private var product: Product?
    
    var threeDaysLater: String {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: 3, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long  // "October 1, 2025"
        return "Expires on \(formatter.string(from: date))"
    }
    
    let baseGuideData: [GuideItem] = [
        GuideItem(image: "guide1",
                  title: "Dual Chat".localized(),
                  subtitleTemplate: "Work and life, switch with one click".localized()),
        GuideItem(image: "guide2",
                  title: "Information Backup".localized(),
                  subtitleTemplate: "Messages are never lost".localized()),
        GuideItem(image: "guide3",
                  title: "Information encryption".localized(),
                  subtitleTemplate: "Protect every message".localized()),
    ]
    var body: some View{
        ZStack{
            if  currentPage == baseGuideData.count {
                guidePayContentView()
            }else{
                guideContentView()
            }
        }
        .fullScreenBackground("loding_bgimage",true)
        .onAppear {
            AnalyticsManager.saveBurialPoint(eventName: "first_in_guide", check: true)
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


extension GuideView {
    @ViewBuilder
    private func guideContentView() -> some View {
        VStack(spacing:16){
            Text(baseGuideData[currentPage].title)
                .foregroundColor(Color(hex: "#101010FF"))
                .font(.custom("PingFangSC-Semibold", size: 20))
            Text(baseGuideData[currentPage].subtitleTemplate)
                .foregroundColor(Color(hex: "#101010FF"))
                .font(.custom("PingFangSC-Medium", size: 14))
            Spacer()
            ZStack(alignment: .bottom){
                Image(baseGuideData[currentPage].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#E9EEF5FF"), Color(hex: "#E3EDF600")]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 330)
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    if currentPage < baseGuideData.count {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }) {
                    CustomText(
                        text: "Continue".localized(),
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
                .padding(.horizontal, 24)
                .padding(.bottom, safeBottom + 52)
            }
        }
        .padding(.top, safeTop + 50)
    }
    
    @ViewBuilder
    private func guidePayContentView() -> some View {
        
        let images = ["guide_scr_img1", "guide_scr_img2", "guide_scr_img3", "guide_scr_img4"]
        let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

        ZStack(alignment: .top){

            TabView(selection: $currentIndex) {
                ForEach(Array(images.enumerated()), id: \.offset) { index, name in
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: 320)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 320)
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % images.count
                }
            }
            .padding(.top, safeTop + 16)
            
            VStack{
                Spacer()
                VStack(spacing:0){
                    CustomText(
                        text: "Free 3-day upgrade to Pro version?".localized(),
                        fontName: Constants.FontString.semibold,
                        fontSize: 16,
                        colorHex: "#101010FF"
                    )
                    .padding(.top,16)
                    CustomText(
                        text: "No commitment required, cancel anytime".localized(),
                        fontName: Constants.FontString.medium,
                        fontSize: 14,
                        colorHex: "#7D7D7DFF"
                    )
                    .padding(.top,12)
                    
                    VStack(spacing:5){
                        HStack{
                            GradientText(
                                text: "What Pro",
                                colors: [Color(hex: "#12FF3CFF"), Color(hex: "#0EB0FFFF")],
                                font: .custom(Constants.FontString.semibold, size: 16)
                            )
                            .padding(.horizontal,12)
                            .padding(.top,10)
                            Spacer()
                        }
                        CustomText(text: "Dual Chat, message backup, privacy protection, unlimited text translation.".localized(),
                                   fontName: Constants.FontString.medium,
                                   fontSize: 14,
                                   colorHex: "#7D7D7DFF")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal,12)
                        
                        HStack{
                            CustomText(
                                text: "Or continue using the restricted version".localized(),
                                fontName: Constants.FontString.medium,
                                fontSize: 14,
                                colorHex: "#7D7D7DFF"
                            )
                            Image("guide_icon2")
                                .resizable()
                                .frame(width: 20,height: 20)
                            Spacer()
                        }
                        .padding(.horizontal,12)
                        .padding(.bottom,10)
                        .onTapGesture {
                            onComplete()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal,16)
                    .background(Color(hex: "#E1FFDEFF"))
                    .cornerRadius(20)
                    .padding(.top,16)
                    
                    HStack{
                        Image("guide_icon1")
                            .frame(width: 20,height: 20)
                        CustomText(
                            text: "Remind me before deducting money".localized(),
                            fontName: Constants.FontString.medium,
                            fontSize: 12,
                            colorHex: "#424242FF"
                        )
                        Toggle("", isOn: $isOn)
                            .labelsHidden()
                            .toggleStyle(.switch)
                            .padding()
                    }
                    .padding(.horizontal,16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "#F7F6FFFF"), Color(hex: "#E6F5FFFF")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(30)
                    .padding(.top,16)
                    
                    Button(action: {
                        AnalyticsManager.saveBurialPoint(eventName: "first_in_buy_vip", check: true)
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
                    .padding(.top,10)
                    

                    
                    HStack{
                        Image("guide_icon3")
                        VStack(spacing:4){
                            HStack{
                                CustomText(
                                    text: "today".localized(),
                                    fontName: Constants.FontString.medium,
                                    fontSize: 12,
                                    colorHex: "#101010FF"
                                )
                                Spacer()
                                CustomText(
                                    text: "3 days free".localized(),
                                    fontName: Constants.FontString.medium,
                                    fontSize: 12,
                                    colorHex: "#00B81CFF"
                                )
                                
                                CustomText(
                                    text: (product?.priceFormatStyle.locale.currencySymbol ?? "$") + "0.00",
                                    fontName: Constants.FontString.medium,
                                    fontSize: 12,
                                    colorHex: "#101010FF"
                                )
                            }
                            HStack{
                                CustomText(
                                    text: threeDaysLater,
                                    fontName: Constants.FontString.medium,
                                    fontSize: 12,
                                    colorHex: "#7D7D7DFF"
                                )
                                Spacer()
                                CustomText(
                                    text: "Week".localized(),
                                    fontName: Constants.FontString.medium,
                                    fontSize: 12,
                                    colorHex: "#7D7D7DFF"
                                )
                                

                                CustomText(
                                    text: product?.displayPrice ?? "$9.99",
                                    fontName: Constants.FontString.medium,
                                    fontSize: 12,
                                    colorHex: "#7D7D7DFF"
                                )
                            }
                        }
                    }
                    .padding(.top,8)
                    .padding(.horizontal,16)
                    
                    HStack(spacing:0){
                        CustomText(
                            text: "terms".localized(),
                            fontName: Constants.FontString.medium,
                            fontSize: 10,
                            colorHex: "#838383FF"
                        )
                        .underline()
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "https://sites.google.com/view/dual-chat-terms-of-service")!)
                        }
                        
                        CustomText(
                            text: "&",
                            fontName: Constants.FontString.medium,
                            fontSize: 10,
                            colorHex: "#838383FF"
                        )
                        
                        CustomText(
                            text: "privacy".localized(),
                            fontName: Constants.FontString.medium,
                            fontSize: 10,
                            colorHex: "#838383FF"
                        )
                        .underline()
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "https://sites.google.com/view/dual-chat-privacy-policy")!)
                        }
                        Spacer()
                        CustomText(
                            text: "recover".localized(),
                            fontName: Constants.FontString.medium,
                            fontSize: 10,
                            colorHex: "#838383FF"
                        )
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
                    .padding(.horizontal,16)
                    .padding(.top,10)
                    .padding(.bottom,safeBottom)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal,16)
                .background(.white)
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
            }
        }
        .onAppear{
            AnalyticsManager.saveBurialPoint(eventName: "first_in_vip", check: true)
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

                //修改支付结果
                settings.hasWhatsPayStatus = true
                LoadingMaskManager.shared.hide()
                onComplete()
            }
        }
        .onReceive(payManager.$purchaseError) { error in
            if error != nil {
                LoadingMaskManager.shared.hide()
                onPayCancelComplete()
            }
        }
    }
}
