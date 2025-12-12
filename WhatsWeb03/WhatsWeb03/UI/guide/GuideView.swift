//
//  GuideView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import SwiftUI
import Combine


struct GuideItem {
    let image: String
    let title: String
    let subtitleTemplate: String
}

struct GuideView: View {
    
    var onComplete: () -> Void
    var onPayCancelComplete:() -> Void
    
    @State private var currentPage = 3
    
    @State var currentIndex = 0
    @State private var isOn: Bool = false
    
    let baseGuideData: [GuideItem] = [
        GuideItem(image: "guide1",
                  title: "Dual Chat".localized(),
                  subtitleTemplate: "工作生活，一键切换".localized()),
        GuideItem(image: "guide2",
                  title: "信息备份".localized(),
                  subtitleTemplate: "消息永不丢失".localized()),
        GuideItem(image: "guide3",
                  title: "信息加密".localized(),
                  subtitleTemplate: "安全守护每条消息".localized()),
    ]
    var body: some View{
        ZStack{
            Image("loding_bgimage")
                .resizable()
            if  currentPage == baseGuideData.count {
                guidePayContentView()
            }else{
                guideContentView()
            }
        }
        .ignoresSafeArea()
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
                        text: "免费 3 天升级到专业版？".localized(),
                        fontName: Constants.FontString.semibold,
                        fontSize: 16,
                        colorHex: "#101010FF"
                    )
                    .padding(.top,16)
                    CustomText(
                        text: "无需承诺，随时取消".localized(),
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
                        CustomText(text: "Dual Chat、消息备份、隐私保护、无限翻译文本".localized(),
                                   fontName: Constants.FontString.medium,
                                   fontSize: 14,
                                   colorHex: "#7D7D7DFF")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal,12)
                        
                        HStack{
                            CustomText(
                                text: "或继续使用受限版本".localized(),
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
                            print("aa")
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
                            text: "扣款前提醒我",
                            fontName: Constants.FontString.medium,
                            fontSize: 12,
                            colorHex: "#424242FF"
                        )
                        Toggle("", isOn: $isOn)
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
                        onPayCancelComplete()
                    }) {
                        
                        CustomText(
                            text: "免费试用".localized(),
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
                                    text: "今天".localized(),
                                    fontName: Constants.FontString.medium,
                                    fontSize: 12,
                                    colorHex: "#101010FF"
                                )
                                Spacer()
                                CustomText(
                                    text: "3天免费".localized(),
                                    fontName: Constants.FontString.medium,
                                    fontSize: 12,
                                    colorHex: "#00B81CFF"
                                )
                                CustomText(
                                    text: "$0.00",
                                    fontName: Constants.FontString.medium,
                                    fontSize: 12,
                                    colorHex: "#101010FF"
                                )
                            }
                            HStack{
                                CustomText(
                                    text: "2025 年 10 月 1 日到期",
                                    fontName: Constants.FontString.medium,
                                    fontSize: 12,
                                    colorHex: "#7D7D7DFF"
                                )
                                Spacer()
                                CustomText(
                                    text: "周".localized(),
                                    fontName: Constants.FontString.medium,
                                    fontSize: 12,
                                    colorHex: "#7D7D7DFF"
                                )
                                
                                CustomText(
                                    text: "$9.99",
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
                            text: "条款".localized(),
                            fontName: Constants.FontString.medium,
                            fontSize: 10,
                            colorHex: "#838383FF"
                        )
                        .underline()
                        
                        CustomText(
                            text: "&",
                            fontName: Constants.FontString.medium,
                            fontSize: 10,
                            colorHex: "#838383FF"
                        )
                        
                        CustomText(
                            text: "隐私".localized(),
                            fontName: Constants.FontString.medium,
                            fontSize: 10,
                            colorHex: "#838383FF"
                        )
                        .underline()
                        Spacer()
                        CustomText(
                            text: "恢复".localized(),
                            fontName: Constants.FontString.medium,
                            fontSize: 10,
                            colorHex: "#838383FF"
                        )
                        .underline()
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
    }
}

#Preview {
    GuideView(onComplete: {
        
    }, onPayCancelComplete: {
        
    })
}
