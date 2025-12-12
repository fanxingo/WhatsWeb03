//
//  String.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//
import Foundation

extension String {
    func localized(_ args: CVarArg...) -> String {
        let format = Bundle.main.localizedString(forKey: self, value: nil, table: nil)
        return String(format: format, arguments: args)
    }
}
