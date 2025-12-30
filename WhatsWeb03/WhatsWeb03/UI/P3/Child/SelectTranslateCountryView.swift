//
//  SelectTranslateCountryView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/24.
//


import SwiftUI

struct SelectTranslateCountryView:View {
    
    @Environment(\.dismiss) var dismiss
    
    var onComplete: (Locale) -> Void
    var selectLocale: Locale? = nil
    
    private var uniqueLanguageLocales: [Locale] {
        var seen = Set<String>()
        return Locale.availableIdentifiers.compactMap { identifier in
            let locale = Locale(identifier: identifier)
            guard let code = locale.language.languageCode?.identifier else { return nil }
            if seen.contains(code) { return nil }
            seen.insert(code)
            return locale
        }.sorted {
            let lhs = Locale.current.localizedString(forLanguageCode: $0.language.languageCode?.identifier ?? "") ?? ""
            let rhs = Locale.current.localizedString(forLanguageCode: $1.language.languageCode?.identifier ?? "") ?? ""
            return lhs < rhs
        }
    }
    

    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {

                HStack {
                    CustomText(
                        text: "选择语言".localized(),
                        fontName: Constants.FontString.medium,
                        fontSize: 16,
                        colorHex: "#00B81CFF"
                    )
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        CustomText(
                            text: "取消".localized(),
                            fontName: Constants.FontString.medium,
                            fontSize: 12,
                            colorHex: "#A9A9A9FF"
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                Divider()

                List {
                    ForEach(uniqueLanguageLocales, id: \.identifier) { locale in
                        let languageCode = locale.language.languageCode?.identifier ?? ""
                        let languageName = Locale.current.localizedString(forLanguageCode: languageCode) ?? locale.identifier

                        Button(action: {
                            onComplete(locale)
                            dismiss()
                        }) {
                            HStack {
                                CustomText(text: languageName, fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#101010FF")

                                Spacer()

                                if selectLocale?.language.languageCode?.identifier ==
                                   locale.language.languageCode?.identifier {
                                    Image("lab_icon14")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20,height: 20)
                                }
                            }
                            .padding(.horizontal,16)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}
