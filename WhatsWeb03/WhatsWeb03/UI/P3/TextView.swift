//
//  TextView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//

import SwiftUI

struct TextView: View{
    
    @Binding var currentTab: CustomTab
    
    @State private var showFullPayScreen = false
    
    var body: some View{
        ZStack{
            VStack{
                TitleView(showFullPayScreen: $showFullPayScreen, title: "Text Lab".localized())
                ScrollView{
                    VStack(spacing:0){
                        longItemButtonsSection()
                        LineSpace(title: "工具".localized())
                            .padding(.top,8)
                        shortItemsGridSection()
                        Color.clear
                            .frame(height: safeBottom + 80)
                        Spacer()
                    }
                }
                .scrollIndicators(.hidden)
                Spacer()
            }
            .padding(.top,safeTop)
            .padding(.horizontal,16)
        }
        .fullScreenBackground("loding_bgimage")
        .fullScreenCover(isPresented: $showFullPayScreen) {
            PayView()
        }
    }
    
    private enum TextToolAction {
        case fastSend, artFont, emoji, commonPhrase
        case translate, repeatText, reverse, shuffle, textToEmoji
    }
    
    private func handleAction(_ action: TextToolAction) {
        switch action {
        case .fastSend:
            print("fastSend tapped")
        case .artFont:
            print("artFont tapped")
        case .emoji:
            print("emoji tapped")
        case .commonPhrase:
            print("commonPhrase tapped")
        case .translate:
            print("translate tapped")
        case .repeatText:
            print("repeat tapped")
        case .reverse:
            print("reverse tapped")
        case .shuffle:
            print("shuffle tapped")
        case .textToEmoji:
            print("textToEmoji tapped")
        }
    }
}

// MARK: - Extracted Sections
extension TextView {
    // Data for LongItemView buttons
    private var longItemButtons: [(iconImg: String, title: String, desc: String, action: TextToolAction)] {
        [
            ("lab_icon1", "快速发送".localized(), "让回复更快一步".localized(), .fastSend),
            ("lab_icon2", "艺术字体".localized(), "让文字更有态度".localized(), .artFont),
            ("lab_icon3", "表情符号".localized(), "用情绪表达比文字更直接".localized(), .emoji),
            ("lab_icon4", "常用短语".localized(), "一键开启有趣对话氛围".localized(), .commonPhrase)
        ]
    }
    // Data for ShortItemView grid (2 per row, last row may have one item)
    private var shortItems: [(isVip: Bool, iconImg: String, title: String, action: TextToolAction)] {
        [
            (false, "lab_icon6", "文本翻译".localized(), .translate),
            (true, "lab_icon7", "重复文本".localized(), .repeatText),
            (true, "lab_icon8", "翻转文本".localized(), .reverse),
            (true, "lab_icon9", "随机排列单词".localized(), .shuffle),
            (true, "lab_icon10", "文本转表情符号".localized(), .textToEmoji)
        ]
    }

    @ViewBuilder
    private func longItemButtonsSection() -> some View {
        VStack(spacing: 8) {
            ForEach(longItemButtons, id: \.iconImg) { item in
                Button(action: { handleAction(item.action) }) {
                    LongItemView(iconImg: item.iconImg, title: item.title, desc: item.desc)
                }
            }
        }
    }

    @ViewBuilder
    private func shortItemsGridSection() -> some View {
        // Group items into rows of 2, last row may have 1
        let rows = stride(from: 0, to: shortItems.count, by: 2).map { i -> Array<(Bool, String, String, TextToolAction)> in
            Array(shortItems[i..<min(i+2, shortItems.count)])
        }
        ForEach(0..<rows.count, id: \.self) { rowIdx in
            HStack {
                ForEach(0..<rows[rowIdx].count, id: \.self) { colIdx in
                    let item = rows[rowIdx][colIdx]
                    Button(action: { handleAction(item.3) }) {
                        ShortItemView(isVip: item.0, iconImg: item.1, title: item.2)
                    }
                }
                // If this row has only one item, fill space and keep Color.clear for layout
                if rows[rowIdx].count == 1 {
                    Spacer()
                    Color.clear
                }
            }
        }
    }
}

extension TextView{
    private struct ShortItemView:View {
        
        var isVip:Bool
        var iconImg:String
        var title:String
        
        var body: some View {
            ZStack(alignment:.topTrailing){
                HStack(spacing: 10) {
                    Image(iconImg)
                        .resizable()
                        .frame(width: 34, height: 34)
                    CustomText(
                        text: title,
                        fontName: Constants.FontString.medium,
                        fontSize: 14,
                        colorHex: "#101010FF"
                    )
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16))
                .background(
                    Image("home_linebg_item3")
                        .resizable(
                            capInsets: EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20),
                            resizingMode: .stretch
                        )
                )
                .padding(.top,8)
                
                if !isVip {
                    Image("lab_icon5")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26,height: 26)
                        .padding(.trailing,0)
                }
            }
        }
    }
    
    private struct LongItemView:View {
        var iconImg : String
        var title : String
        var desc : String

        var body: some View{
            ZStack{
                HStack(spacing: 10) {
                    Image(iconImg)
                        .resizable()
                        .frame(width: 34, height: 34)

                    VStack(alignment: .leading, spacing: 4) {
                        CustomText(
                            text: title,
                            fontName: Constants.FontString.medium,
                            fontSize: 14,
                            colorHex: "#101010FF"
                        )

                        CustomText(
                            text: desc,
                            fontName: Constants.FontString.medium,
                            fontSize: 12,
                            colorHex: "#7D7D7DFF"
                        )
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()

                    Image("home_arrow")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(EdgeInsets(top: 16, leading: 24, bottom: 24, trailing: 24))
                .background(
                    Image("home_linebg_item3")
                        .resizable(
                            capInsets: EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20),
                            resizingMode: .stretch
                        )
                )
            }
        }
    }
}
