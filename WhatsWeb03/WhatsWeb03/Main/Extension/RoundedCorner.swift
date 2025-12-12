//
//  RoundedCorner.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = 10
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct GradientText: View {
    var text: String
    var colors: [Color]
    var font: Font
    var alignment: TextAlignment = .center
    var starPoint: UnitPoint = .leading
    var endPoint: UnitPoint = .trailing
    var lineSpacing: CGFloat = 0
    var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(LinearGradient(colors: colors, startPoint: starPoint, endPoint: endPoint))
            .multilineTextAlignment(alignment)
            .lineSpacing(lineSpacing)
            .fixedSize(horizontal: false, vertical: true)
    }
}
