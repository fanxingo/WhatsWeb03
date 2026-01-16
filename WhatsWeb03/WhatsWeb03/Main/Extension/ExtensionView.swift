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
    @EnvironmentObject var settings: SettingsManager
    @Binding var showFullPayScreen: Bool
    let title:String
    var body: some View {
        ZStack {
            TitleText(title: title)

            if !settings.hasWhatsPayStatus {
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
}

struct FullScreenBackground: ViewModifier {
    let imageName: String
    var ignore: Bool = true

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(imageName)
                    .resizable()
                    .scaledToFill()
            )
            .ignoresSafeArea(ignore ? .all : [])
    }
}
struct FullScreenColorBackground: ViewModifier {
    let hex: String
    var ignore: Bool = true
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(hex: hex)
            )
        .ignoresSafeArea(ignore ? .all : [])
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


struct BorderedTextEditor: View {
    @Binding var text: String
    var placeholder: String
    
    // 背景与边框配置
    var backgroundColor: Color = .white
    var borderColor: Color = Color.gray.opacity(0.3)
    var borderWidth: CGFloat = 1
    var cornerRadius: CGFloat = 10
    
    // 尺寸配置
    var minHeight: CGFloat = 100
    var maxHeight: CGFloat = 150
    
    // 字体与颜色配置
    var editorFont: Font = .system(size: 14)
    var textColor: Color = Color(hex: "#363636FF")
    var placeholderColor: Color = .gray
    
    // 边距配置
    var textInsets: CGFloat = 8      // TextEditor 内部的 padding
    var placeholderPadding: EdgeInsets = EdgeInsets(top: 14, leading: 14, bottom: 0, trailing: 0)

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(editorFont)
                .foregroundColor(textColor)
                .frame(minHeight: minHeight, maxHeight: maxHeight)
                .padding(textInsets)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )

            if text.isEmpty {
                Text(placeholder)
                    .font(editorFont) // 建议占位符字体与输入字体一致
                    .foregroundColor(placeholderColor)
                    .padding(placeholderPadding)
                    // 禁用点击，防止挡住 TextEditor 的触摸事件
                    .allowsHitTesting(false)
            }
        }
    }
}


struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(at: .zero, in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        _ = layout(at: bounds.origin, in: bounds.width, subviews: subviews, isPlacing: true)
    }

    private func layout(at corner: CGPoint, in maxWith: CGFloat, subviews: Subviews, isPlacing: Bool = false) -> (size: CGSize, lastY: CGFloat) {
        var x = corner.x
        var y = corner.y
        var rowHeight: CGFloat = 0
        var maxWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > corner.x + maxWith {
                x = corner.x
                y += rowHeight + spacing
                rowHeight = 0
            }

            if isPlacing {
                subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            }

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxWidth = max(maxWidth, x)
        }

        return (CGSize(width: maxWidth, height: y + rowHeight - corner.y), y + rowHeight)
    }
}
