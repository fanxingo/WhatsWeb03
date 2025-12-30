//
//  ChatNoneCellView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/29.
//

import SwiftUI

struct ChatNoneCellView: View {
    let text: String

    var body: some View {
        ZStack {
            CustomText(
                text: text,
                fontName: Constants.FontString.medium,
                fontSize: 10,
                colorHex: "#AEAEAEFF"
            )
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
    }
}
