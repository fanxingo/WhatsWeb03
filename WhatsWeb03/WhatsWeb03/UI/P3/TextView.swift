//
//  TextView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//

import SwiftUI

struct TextView: View{
    
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var settings: SettingsManager
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
        .fullScreenBackground("loding_bgimage",true)
        .fullScreenCover(isPresented: $showFullPayScreen) {
            PayView()
        }
    }
    
    private enum TextToolAction {
        case fastSend, artFont, emoji, commonPhrase
        case translate, repeatText, reverse, shuffle, textToEmoji
    }
    
    private func handleAction(_ action: TextToolAction) {
        
        
        if !settings.hasWhatsPayStatusTest{
            showFullPayScreen.toggle()
            return
        }
        
        switch action {
        case .fastSend:
            navManager.path.append(AppRoute.sendQuicklyView)
        case .artFont:
            navManager.path.append(AppRoute.artisticFontsView)
        case .emoji:
            navManager.path.append(AppRoute.emojisView)
        case .commonPhrase:
            navManager.path.append(AppRoute.commonPhraseView)
        case .translate:
            navManager.path.append(AppRoute.translateView)
        case .repeatText:
            navManager.path.append(AppRoute.repeatingTextView)
        case .reverse:
            navManager.path.append(AppRoute.flipTextView)
        case .shuffle:
            navManager.path.append(AppRoute.shuffleView)
        case .textToEmoji:
            navManager.path.append(AppRoute.convertTextEmojiView)
        }
    }
}

// MARK: - Extracted Sections
extension TextView {
    // Data for LongItemView buttons
    private var longItemButtons: [(iconImg: String, title: String, desc: String, action: TextToolAction)] {
        [
            ("lab_icon1", "Send quickly".localized(), "Make your reply faster".localized(), .fastSend),
            ("lab_icon2", "Artistic Fonts".localized(), "Make words more expressive".localized(), .artFont),
            ("lab_icon3", "emojis".localized(), "Expressing emotions is more direct than using words.".localized(), .emoji),
            ("lab_icon4", "Common phrases".localized(), "Start a fun conversation with one click".localized(), .commonPhrase)
        ]
    }
    // Data for ShortItemView grid (2 per row, last row may have one item)
    private var shortItems: [(isVip: Bool, iconImg: String, title: String, action: TextToolAction)] {
        [
            (settings.hasWhatsPayStatusTest, "lab_icon6", "Text translation".localized(), .translate),
            (settings.hasWhatsPayStatusTest, "lab_icon7", "Repeated text".localized(), .repeatText),
            (settings.hasWhatsPayStatusTest, "lab_icon8", "Flip text".localized(), .reverse),
            (settings.hasWhatsPayStatusTest, "lab_icon9", "Randomly arrange words".localized(), .shuffle),
            (settings.hasWhatsPayStatusTest, "lab_icon10", "Text to emoji".localized(), .textToEmoji)
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
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 8))
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
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
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
