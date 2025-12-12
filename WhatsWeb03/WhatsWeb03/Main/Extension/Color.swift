//
//  Color.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hexString = hex
            .trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            .uppercased()

        var hexNumber: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&hexNumber) else {
            // 非法 hex，返回透明
            self = Color.clear
            return
        }

        let r, g, b, a: Double

        switch hexString.count {
        case 6:
            // RGB（默认 alpha = 1）
            r = Double((hexNumber & 0xFF0000) >> 16) / 255
            g = Double((hexNumber & 0x00FF00) >> 8)  / 255
            b = Double( hexNumber & 0x0000FF       ) / 255
            a = 1.0

        case 8:
            // RGBA
            r = Double((hexNumber & 0xFF000000) >> 24) / 255
            g = Double((hexNumber & 0x00FF0000) >> 16) / 255
            b = Double((hexNumber & 0x0000FF00) >> 8)  / 255
            a = Double( hexNumber & 0x000000FF       ) / 255

        default:
            // 位数不对，返回透明
            self = Color.clear
            return
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
