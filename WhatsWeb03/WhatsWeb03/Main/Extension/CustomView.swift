//
//  Cus.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//

import SwiftUI

struct CustomText: View {
    let text: String
    var fontName: String = Constants.FontString.medium
    var fontSize: CGFloat = 12
    var colorHex: String = "#000000FF"

    var body: some View {
        Text(text)
            .font(.custom(fontName, size: fontSize))
            .foregroundColor(Color(hex: colorHex))
    }
}
