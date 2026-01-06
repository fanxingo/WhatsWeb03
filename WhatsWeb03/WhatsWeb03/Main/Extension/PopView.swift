//
//  PopView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/15.
//

import SwiftUI

struct DeletePopView: View {
    
    var title:String
    var subString:String = "Sure".localized()
    var cancelString:String = "Cancel".localized()
    var onComplete: () -> Void
    
    var body: some View {
        ZStack(alignment: .center){
            Color(hex: "#29293A33")
            ZStack{
                VStack(spacing:18){
                    CustomText(text: title, fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#000000FF")
                    HStack(){
                        Button(action:{
                            PopManager.shared.dismiss()
                        }){
                            CustomText(
                                text: cancelString,
                                fontName: Constants.FontString.medium,
                                fontSize: 17,
                                colorHex: "#000000FF"
                            )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 13)
                                .background(
                                    Color(hex: "#78788029")
                                )
                                .cornerRadius(24)
                        }
                        Spacer()
                        Button(action:{
                            onComplete()
                            PopManager.shared.dismiss()
                        }){
                            CustomText(
                                text: subString,
                                fontName: Constants.FontString.medium,
                                fontSize: 17,
                                colorHex: "#FFFFFFFF"
                            )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 13)
                                .background(
                                    Color(hex: "#00B81CFF")
                                )
                                .cornerRadius(24)
                        }
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: 300)
            .background(
                Image("pop_ground_image")
                    .resizable(capInsets: EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
                    .cornerRadius(34)
                    .opacity(0.95)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}

struct WenMenuPopView: View {
    
    @State var isMain : Int = 0
    @State private var emojiList: [String] = []
    @State private var phraseList: [String] = []
    
    var body: some View {
        ZStack(alignment: .bottom){
            Color(hex: "#29293A33")
                .onTapGesture {
                    PopManager.shared.dismiss()
                }
            if isMain == 0 {
                MainView()
            }else if isMain == 1{
                FaceView()
            }else{
                PhraseView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func MainView() -> some View{
        VStack(spacing:0){
            Divider()
                .frame(width: 20,height: 4)
                .background(
                    Color(hex: "#D9D9D9")
                )
                .cornerRadius(2)
                .padding(.top,4)
            HStack{
                CustomText(text: "menu".localized(), fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#00B81C")
                Spacer()
                Button(action:{
                    PopManager.shared.dismiss()
                }){
                    CustomText(text: "Cancel".localized(), fontName: Constants.FontString.medium, fontSize: 12, colorHex: "#A9A9A9")
                }
            }
            .padding(.horizontal,16)
            .padding(.top,10)
            
            HStack {
                Image("web_pop_icon1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)

                CustomText(
                    text: "emojis".localized(),
                    fontName: Constants.FontString.medium,
                    fontSize: 14,
                    colorHex: "#101010"
                )

                Spacer()

                Image("home_arrow")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "#F1F1F1"), lineWidth: 1)
            )
            .padding(.horizontal,16)
            .padding(.top,16)
            .onTapGesture {
                isMain = 1
            }
            
            HStack {
                Image("web_pop_icon2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)

                CustomText(
                    text: "Common phrases".localized(),
                    fontName: Constants.FontString.medium,
                    fontSize: 14,
                    colorHex: "#101010"
                )

                Spacer()

                Image("home_arrow")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "#F1F1F1"), lineWidth: 1)
            )
            .padding(.horizontal,16)
            .padding(.top,16)
            .onTapGesture {
                isMain = 2
            }

        }
        .safeAreaPadding(.bottom)
        .padding(.bottom,20)
        .frame(maxWidth: .infinity)
        .background(
            Color.white
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft,.topRight]))
        )
    }
    
    @ViewBuilder
    private func FaceView() -> some View{
        VStack(spacing:0){
            Divider()
                .frame(width: 20,height: 4)
                .background(
                    Color(hex: "#D9D9D9")
                )
                .cornerRadius(2)
                .padding(.top,4)
            ZStack{
                CustomText(text: "emojis".localized(), fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#101010")
                HStack{
                    Button(action:{
                        isMain = 0
                    }){
                        Image("nav_back_image")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44,height: 44)
                    }
                    Spacer()
                }
            }
            .padding(.top,8)
            .padding(.horizontal,16)
            ZStack{
                ScrollView {

                    FlowLayout(spacing: 12) {
                        ForEach(emojiList.indices, id: \.self) { index in
                            let emoji = emojiList[index]

                            CustomText(
                                text: emoji,
                                fontName: Constants.FontString.medium,
                                fontSize: 14,
                                colorHex: "#101010FF"
                            )
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "#DCDCDCFF"), lineWidth: 1)
                            )
                            .onTapGesture {
                                UIPasteboard.general.string = emoji
                                ToastManager.shared.showToast(message: "Copy successful".localized())
                            }
                        }
                    }

                }
                .scrollIndicators(.hidden)
            }
            .frame(width:UIScreen.main.bounds.width - 32,height: 300)
            .padding(.top,16)
        }
        .safeAreaPadding(.bottom)
        .padding(.bottom,20)
        .frame(maxWidth: .infinity)
        .background(
            Color.white
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft,.topRight]))
        )
        .onAppear {
            loadEmojis()
        }
    }
    
    @ViewBuilder
    private func PhraseView() -> some View{
        VStack(spacing:0){
            Divider()
                .frame(width: 20,height: 4)
                .background(
                    Color(hex: "#D9D9D9")
                )
                .cornerRadius(2)
                .padding(.top,4)
            ZStack{
                CustomText(text: "Common phrases".localized(), fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#101010")
                HStack{
                    Button(action:{
                        isMain = 0
                    }){
                        Image("nav_back_image")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44,height: 44)
                    }
                    Spacer()
                }
            }
            .padding(.top,8)
            .padding(.horizontal,16)
            ZStack{

                List {
                    ForEach(phraseList, id: \.self) { phrase in
                        PhraseRow(phrase: phrase)
                    }
                }
                .listStyle(.plain)
                .environment(\.defaultMinListRowHeight, 0)
                .scrollIndicators(.hidden)
            }
            .frame(width:UIScreen.main.bounds.width - 32,height: 300)
            .padding(.top,16)
        }
        .safeAreaPadding(.bottom)
        .padding(.bottom,20)
        .frame(maxWidth: .infinity)
        .background(
            Color.white
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft,.topRight]))
        )
        .onAppear {
            loadPhrases()
        }
    }
    
    private func loadEmojis() {
        if let url = Bundle.main.url(forResource: "emojis", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedData = try? JSONDecoder().decode(EmojiData.self, from: data) {
            self.emojiList = decodedData.emojis
        }
    }
    private func loadPhrases() {
        if let url = Bundle.main.url(forResource: "commonphrase", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedData = try? JSONDecoder().decode(PhraseData.self, from: data) {
            self.phraseList = decodedData.phrases
        }
    }
}
