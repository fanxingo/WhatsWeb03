//
//  Artistic FontsView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/22.
//

import SwiftUI

let defaultArray: [String] = [
    "A","a","B","b","C","c","D","d","E","e","F","f",
    "G","g","H","h","I","i","J","j","K","k","L","l",
    "M","m","N","n","O","o","P","p","Q","q","R","r",
    "S","s","T","t","U","u","V","v","W","w","X","x",
    "Y","y","Z","z"
]


struct ArtisticFontsView : View {
    
    @Environment(\.dismiss) var dismiss

    @State var inputText : String = ""
    @State private var fontStyles: [[String]] = []
    @State private var resultList: [String] = []
    private let placeholderText = "Add text here to get started".localized()
    
    var body: some View {
        VStack {
            TopSearchView()
            ListView()
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationBarHidden(true)
        .dismissKeyboardOnTap()
        .onAppear {
            loadFonts()
        }
        .onChange(of: inputText) { oldValue, newValue in
            updateResultList(text: newValue)
        }
    }
    
    private func loadFonts() {
        guard let url = Bundle.main.url(forResource: "artisticfont", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let fonts = json["fonts"] as? [[String]] else {
            return
        }

        fontStyles = fonts

        let text = inputText.isEmpty ? placeholderText : inputText
        updateResultList(text: text)
    }
    private func isLetter(_ char: Character) -> Bool {
        char.isLetter && char.unicodeScalars.first!.isASCII
    }
    private func transform(text: String, style: [String]) -> String {
        var result = ""

        for char in text {
            let str = String(char)

            guard isLetter(char),
                  let index = defaultArray.firstIndex(of: str),
                  index < style.count else {
                result.append(str)
                continue
            }

            result.append(style[index])
        }

        return result
    }

    private func updateResultList(text: String) {
        guard !text.isEmpty else {
            resultList = []
            return
        }

        resultList = fontStyles.map { style in
            transform(text: text, style: style)
        }
    }
}

extension ArtisticFontsView{
    
    @ViewBuilder
    private func TopSearchView() -> some View{
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image("nav_back_image")
                        .resizable()
                        .frame(width: 44, height: 44)
                }
                Spacer()
                CustomText(text: "Artistic Fonts".localized(), fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#101010FF")
                Spacer()

                Spacer()
                    .frame(width: 44)
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            ZStack {
                Image("message_icon1")
                    .resizable()
                    .scaledToFit()
                HStack {
                    TextField("Add text here to get started".localized(), text: $inputText)
                        .foregroundColor(Color(hex: "#101010FF"))
                        .font(.system(size: 12, weight: .medium))
                    Spacer()
                    Button(action:{
                        inputText = ""
                    }){
                        Image("lab_icon11")
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.horizontal, 16)
        .background(
            LinearGradient(gradient: Gradient(colors:
                                                [Color(hex: "#F7F6FFFF"),
                                                 Color(hex: "#E6F5FFFF")]),
                           startPoint: .leading, endPoint: .trailing)
                .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))
                .ignoresSafeArea(edges: .top)
        )
    }
    
    private func ListView() -> some View {
        List {
            ForEach(resultList, id: \.self) { text in
                HStack{
                    CustomText(text: text,
                               fontName: Constants.FontString.medium,
                               fontSize: 14,
                               colorHex: "#363636FF")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                    Image("lab_icon12")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(.trailing,20)
                        .onTapGesture {
                            UIPasteboard.general.string = text
                            ToastManager.shared.showToast(message: "Copy successful".localized())
                        }
                }
                .frame(minHeight: 44)
                .padding(.vertical,4)
                .background(Color.white)
                .contentShape(Rectangle())
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "#DCDCDCFF"), lineWidth: 1)
                )
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
}
