//
//  Tips.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//

import SwiftUI


struct TipsAffirmView : View {
    
    var onComplete: () -> Void
    
    @State private var remindMe = false
    @State private var showCloseButton = false

    var priceText: AttributedString {
        let price = "$9.99"
        let rawString = "Dual Chat、消息备份、隐私保护、无限翻译文本等，3天免费试用，然后%@/周，随时取消".localized(price)
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
                            text: "有疑问？",
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
                                CustomText(text: "您可以随时取消订阅", fontName: Constants.FontString.semibold, fontSize: 16, colorHex: "#101010FF")
                                CustomText(text: "无需现在付款", fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#00B81CFF")
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
                        
                        CustomText(text: "您的免费试用如何运作".localized(), fontName: Constants.FontString.semibold, fontSize: 20, colorHex: "#00B81CFF")
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
                                CustomText(text: "今天".localized(), fontName: Constants.FontString.semibold, fontSize: 14, colorHex: "#101010FF")
                                    .padding(.top,14)
                                CustomText(text: "免费解锁所有功能".localized(), fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#7D7D7DFF")
                                
                                CustomText(text: "第2天：提醒".localized(), fontName: Constants.FontString.semibold, fontSize: 14, colorHex: "#101010FF")
                                    .padding(.top,14)
                                CustomText(text: "提前1天提醒，随时取消以避免收费".localized(), fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#7D7D7DFF")
                                
                                RemindButton(remindMe:$remindMe)
                                
                                CustomText(text: "第3天：试用结束".localized(), fontName: Constants.FontString.semibold, fontSize: 14, colorHex: "#101010FF")
                                    .padding(.top,14)
                                CustomText(text: "您的订阅将在3天试用后开始，可此之前随时取消".localized(), fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#7D7D7DFF")
                            }
                            Spacer()
                        }
                        .padding(.horizontal,40)
                        .padding(.top,16)
                        
                        VStack(alignment: .leading,spacing: 12){
                            CustomText(text: "如何取消?".localized(), fontName: Constants.FontString.semibold, fontSize: 14, colorHex: "#101010FF")
                            CustomText(text: "打开手机设置>Apple，选择“订阅”。选择应用，点击“取消订阅”并确认。".localized(), fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#7D7D7DFF")
                            HStack{
                                Spacer()
                                CustomText(text: "退款保证".localized(), fontName: Constants.FontString.medium, fontSize: 12, colorHex: "#FFB12BFF")
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
                        
                        CustomText(text: "您将获得什么".localized(), fontName: Constants.FontString.semibold, fontSize: 20, colorHex: "#00B81CFF")
                            .padding(.top,16)
                            .padding(.horizontal,16)
                        
                        let names = ["双信使，无缝切换".localized(),
                                     "消息备份".localized(),
                                     "隐私保护".localized(),
                                     "无限翻译文本".localized(),
                                     "解锁所有功能".localized()]

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
                            CustomText(text: "条款".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#838383FF")
                                .underline()
                                .onTapGesture {
                                    UIApplication.shared.open(URL(string: "https://www.baidu.com")!)
                                }
                            CustomText(text: "&", fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#838383FF")
                            CustomText(text: "隐私".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#838383FF")
                                .underline()
                                .onTapGesture {
                                    UIApplication.shared.open(URL(string: "https://www.baidu.com")!)
                                }
                            Spacer()
                            if showCloseButton{
                                CustomText(text: "限制版".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#838383FF")
                                    .underline()
                                    .onTapGesture {
                                        onComplete()
                                    }
                            }
                            Spacer()
                            CustomText(text: "恢复".localized(), fontName: Constants.FontString.medium, fontSize: 10, colorHex: "#838383FF")
                                .underline()
                        }
                        .padding(24)
        
                        
                    }
                }
                .scrollIndicators(.hidden)
                BottomView(remindMe: $remindMe, onComplete: {
                    onComplete()
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
                    CustomText(text: remindMe ? "您将收到通知".localized() : "提醒我".localized(), fontName: Constants.FontString.medium, fontSize: 12, colorHex: "#00B81CFF")
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
                    HStack {
                        Image("guide_icon1")
                            .resizable()
                            .frame(width: 20,height: 20)
                        CustomText(
                            text: "别担心，到期前会提醒".localized(),
                            fontName: Constants.FontString.medium,
                            fontSize: 12, colorHex: "#424242FF")
                        Toggle("", isOn: $remindMe)
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


#Preview {
    TipsAffirmView(onComplete: {
        
    })
}
