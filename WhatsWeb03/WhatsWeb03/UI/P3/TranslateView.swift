//
//  Untitled.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/23.
//

import SwiftUI

private struct CountryButton: View {
    let locale: Locale?
    let placeholder: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(displayTitle)
                .font(.custom(Constants.FontString.medium, size: 14))
                .foregroundColor(Color(hex: "#101010FF"))
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "#DCDCDCFF"), lineWidth: 1)
                )
        }
    }

    private var displayTitle: String {
        guard let locale,
              let code = locale.language.languageCode?.identifier,
              let name = Locale.current.localizedString(forLanguageCode: code)
        else {
            return placeholder
        }
        return name
    }
}

struct TranslateView: View {

    @Environment(\.dismiss) var dismiss

    @State private var inputString: String = ""
    @State private var createString: String = ""

    // 左侧显示当前手机语言
    @State private var leftLocale: Locale? = nil
    // 右侧可选语言，初始为空
    @State private var rightLocale: Locale? = nil

    @State private var isShowingLeftPicker = false
    @State private var isShowingRightPicker = false

    var body: some View {
        ZStack {
            VStack(spacing: 16){
                HStack(spacing: 16) {
                    // 左侧按钮
                    CountryButton(
                        locale: leftLocale,
                        placeholder: "Select language".localized()
                    ) {
                        isShowingLeftPicker = true
                    }
                    .sheet(isPresented: $isShowingLeftPicker) {
                        SelectTranslateCountryView(onComplete: { locale in
                            leftLocale = locale
                        }, selectLocale: leftLocale)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                    }
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            swap(&leftLocale, &rightLocale)
                        }
                    }) {
                        Image("lab_icon13")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30,height: 30)
                    }


                    CountryButton(
                        locale: rightLocale,
                        placeholder: "Select language".localized()
                    ) {
                        isShowingRightPicker = true
                    }
                    .sheet(isPresented: $isShowingRightPicker) {
                        SelectTranslateCountryView(onComplete: { locale in
                            rightLocale = locale
                        }, selectLocale: rightLocale)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                    }
                }
                .padding(.top,12)

                BorderedTextEditor(text: $inputString,
                                   placeholder: "Please enter the translation content.".localized(),
                                   cornerRadius: 20,
                                   minHeight: 200,
                                   maxHeight: 200)
                
                Button(action:{
                    submitTranslate()
                }){
                    CustomText(text: "Generate".localized(),
                               fontName: Constants.FontString.semibold,
                               fontSize: 14,
                               colorHex: "#FFFFFFFF")
                    .frame(maxWidth: 240,maxHeight: 34)
                    .background(Color(hex: "#00B81CFF"))
                    .cornerRadius(10)
                }
                if !createString.isEmpty {
                    VStack(spacing: 0){
                        HStack{
                            CustomText(text: "Result".localized(), fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#101010FF")
                            Spacer()
                            Button(action:{
                                UIPasteboard.general.string = createString
                                ToastManager.shared.showToast(message: "Copy successful".localized())
                            }){
                                Image("lab_icon12")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .padding()
                        Divider()
                            .padding(.horizontal,16)
                        ScrollView{
                            CustomText(text: createString,fontName: Constants.FontString.medium,fontSize: 14,colorHex: "#101010FF")
                                .padding(16)
                                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
                        }
                    }
                    .background(
                        Color.white
                    )
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "#DCDCDCFF"), lineWidth: 1)
                    )
                    .safeAreaPadding(.bottom)
                }
                Spacer()
            }
            .padding(.horizontal,16)
            
            
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationModifiers(title: "RepeatingText".localized(), onBack: {
            dismiss()
        })
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
        .onAppear{
            leftLocale = Locale.current
        }
    }
    
    
    private func submitTranslate() {
        
        guard !inputString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            
            ToastManager.shared.showToast(message: "Please enter the text to be translated.".localized())
            
            return
        }
        
        
        let params = [
            "uid": UUIDTool.getUUIDInKeychain(),
            "lang": rightLocale?.language.languageCode?.identifier ?? "",
            "text": inputString,
            "source": leftLocale?.language.languageCode?.identifier ?? ""
        ]

        LoadingMaskManager.shared.show()

        let urlString = BaseUrl("/lang.php")
        
        NetworkManager.shared.sendPOST2Request(urlString: urlString, parameters: params) { result in
            DispatchQueue.main.async {
                
                LoadingMaskManager.shared.hide()
                
                switch result {
                case .success(let responseString):

                    if let data = responseString.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let text = json["text"] as? String {

                        createString = text
                    }

                case .failure(let error):
                    print("Translate error:", error)
                }
            }
        }
    }
}
