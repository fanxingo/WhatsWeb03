//
//  ExtensionView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//

import SwiftUI

struct AgreementText: View {
    var body: some View {
        Text(attributedText)
            .font(.custom(Constants.FontString.medium, size: 10))
            .foregroundColor(Color(hex: "#444444FF"))
            .multilineTextAlignment(.center)
    }
    private var attributedText: AttributedString {
        var text = AttributedString("By continuing you agree to our %@ and %@ Subscriptions automatically renew and can be canceled at any time.".localized("Service Policy".localized(),
                                                                                                                                                            "Privacy Policy".localized()))
        // 用户协议
        if let range = text.range(of: "Service Policy".localized()) {
            text[range].foregroundColor = Color(hex: "#00B81CFF")
            text[range].link = URL(string: "app://userAgreement")
        }
        // 隐私政策
        if let range = text.range(of: "Privacy Policy".localized()) {
            text[range].foregroundColor = Color(hex: "#00B81CFF")
            text[range].link = URL(string: "app://privacyPolicy")
        }
        return text
    }
}

struct LineView: View {
    let size : CGSize
    let cornerRadius: CGFloat
    let colors : [Color]
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: size.width, height: size.height)
            .cornerRadius(cornerRadius)
    }
}

struct TitleText: View {
    let title: String
    var body: some View{
        CustomText(text: title, fontName: Constants.FontString.semibold, fontSize: 18, colorHex: "#101010FF")
    }
}

struct TitleView: View {
    @Binding var showFullPayScreen: Bool
    let title:String
    var body: some View {
        ZStack {
            TitleText(title: title)
            HStack {
                Spacer()
                Button(action:{
                    showFullPayScreen = true
                }){
                    Image("home_vip_icon")
                        .frame(width: 24, height: 24)
                }
                .padding(.trailing,12)
            }
        }
    }
}

struct FullScreenBackground: ViewModifier {
    let imageName: String

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(imageName)
                    .resizable()
                    .scaledToFill()
            )
            .ignoresSafeArea(.all)
    }
}

struct LineSpace: View {
    let title:String
    var body: some View {
        HStack{
            LineView(size: CGSizeMake(4, 16), cornerRadius: 8, colors:
                        [Color(hex: "#3CFF5EFF"),
                         Color(hex: "#57C8FFFF")])
            CustomText(text: title,
                       fontName: Constants.FontString.semibold,
                       fontSize: 18,
                       colorHex: "#101010FF")
            Spacer()
        }
    }
}

struct DismissKeyboardOnTapModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
    }
}


struct HighlightedText: View {
    let text: String
    let keyword: String
    let font: Font
    let normalColor: Color
    let highlightColor: Color

    var body: some View {
        if keyword.isEmpty {
            Text(text)
                .font(font)
                .foregroundColor(normalColor)
        } else if let range = text.range(of: keyword, options: .caseInsensitive) {
            let prefix = String(text[..<range.lowerBound])
            let match = String(text[range])
            let suffix = String(text[range.upperBound...])

            (
                Text(prefix).foregroundColor(normalColor) +
                Text(match).foregroundColor(highlightColor) +
                Text(suffix).foregroundColor(normalColor)
            )
            .font(font)
        } else {
            Text(text)
                .font(font)
                .foregroundColor(normalColor)
        }
    }
}


struct NumericKeyboardView: View {
    var onKeyTap: (String) -> Void
    var disableKeys: Bool = false
    
    private let keyboardRows: [[String]] = [
        ["1","2","3"],
        ["4","5","6"],
        ["7","8","9"],
        ["" ,"0","⌫"]
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(keyboardRows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            if !disableKeys {
                                onKeyTap(key)
                            }
                        }) {
                            ZStack {
                                if key == "⌫" {
                                    Image(systemName: "delete.left")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(hex: "#000000FF"))
                                } else {
                                    Text(key)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Color(hex: "#000000FF"))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 65)
                            .contentShape(Rectangle())
                        }
                        .disabled(key.isEmpty || disableKeys)
                    }
                }
            }
        }
    }
}
