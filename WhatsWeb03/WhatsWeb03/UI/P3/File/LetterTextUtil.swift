//
//  Lett.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/23.
//

import Foundation

class LetterTextUtil {
    
    /// 根据字符类型动态匹配占位符
    static func getIsNumOrCharacter(_ str: String) -> String {
        let blank = "\u{3000}"
        let numPattern = "^[0-9]*$"
        let charPattern = "^[a-zA-Z]*$"
        let chinesePattern = "^[\\u4e00-\\u9fa5]*$"
        
        // 使用正则匹配判断字符类型，确保在不同语境下拼出的字母不歪斜
        if str.range(of: numPattern, options: .regularExpression) != nil {
            return "\u{3000}"
        } else if str.range(of: charPattern, options: .regularExpression) != nil {
            return "\u{3000}"
        } else if str.range(of: chinesePattern, options: .regularExpression) != nil {
            return "\u{3000}"
        }
        return blank
    }

    // MARK: - Letters A-Z

    static func letterA(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\n"
    }

    static func letterB(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\n\n"
    }

    static func letterC(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\n\(s)\n\(s)\n\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letterD(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\n\n"
    }

    static func letterE(_ s: String) -> String {
        return "\(s)\(s)\(s)\(s)\(s)\n\(s)\n\(s)\n\(s)\(s)\(s)\(s)\(s)\n\(s)\n\(s)\n\(s)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letterF(_ s: String) -> String {
        return "\(s)\(s)\(s)\(s)\(s)\n\(s)\n\(s)\n\(s)\(s)\(s)\(s)\(s)\n\(s)\n\(s)\n\(s)\n\n"
    }

    static func letterG(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\n\(s)\(b)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letterH(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\n"
    }

    static func letterI(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(s)\(s)\(s)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letterJ(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(s)\(s)\(s)\(s)\(s)\n\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(s)\n\(b)\(s)\(s)\n\n"
    }

    static func letterK(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(b)\(b)\(s)\n\(s)\(b)\(s)\n\(s)\(s)\n\(s)\(s)\n\(s)\(b)\(s)\n\(s)\(b)\(b)\(s)\n\(s)\(b)\(b)\(s)\n\n"
    }

    static func letterL(_ s: String) -> String {
        return "\(s)\n\(s)\n\(s)\n\(s)\n\(s)\n\(s)\n\(s)\(s)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letterM(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\(s)\(s)\(b)\(b)\(b)\(s)\(s)\n\(s)\(b)\(s)\(b)\(s)\(b)\(s)\n\(s)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\n"
    }

    static func letterN(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(s)\(b)\(b)\(s)\n\(s)\(b)\(b)\(s)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\n"
    }

    static func letterO(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letterP(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\n\(s)\n\(s)\n\(s)\n\n"
    }

    static func letterQ(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(s)\(b)\(b)\(s)\n\(s)\(b)\(b)\(s)\(s)\n\(b)\(s)\(s)\(s)\n\n"
    }

    static func letterR(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\n\(s)\(b)\(s)\n\(s)\(b)\(b)\(s)\n\(s)\(b)\(b)\(s)\n\n"
    }

    static func letterS(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(s)\(s)\(s)\(s)\n\(s)\n\(s)\n\(b)\(s)\(s)\(s)\n\(b)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\n\n"
    }

    static func letterT(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(s)\(s)\(s)\(s)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\n"
    }

    static func letterU(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letterV(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(b)\(s)\(b)\(s)\n\(b)\(b)\(s)\n\n"
    }

    static func letterW(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(s)\(b)\(s)\n\(s)\(b)\(s)\(b)\(s)\n\(b)\(s)\(s)\n\n"
    }

    static func letterX(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(b)\(b)\(s)\n\(b)\(b)\(s)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\(b)\(b)\(s)\(b)\(s)\n\(b)\(s)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\n"
    }

    static func letterY(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(b)\(b)\(s)\n\(b)\(b)\(s)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\n"
    }

    static func letterZ(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(s)\(s)\(s)\(s)\(s)\n\(b)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(b)\(s)\n\(s)\n\(s)\(s)\(s)\(s)\(s)\(s)\n\n"
    }

    // MARK: - Numbers 0-9

    static func letter0(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(b)\(s)\(s)\n\(b)\(s)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(b)\(b)\(s)\n\(b)\(b)\(s)\(s)\n\n"
    }

    static func letter1(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(b)\(s)\n\(b)\(s)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letter2(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(b)\(s)\n\(s)\n\(s)\(s)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letter3(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letter4(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(b)\(s)\(s)\n\(b)\(b)\(s)\(b)\(s)\(s)\n\(b)\(s)\(b)\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\(s)\(s)\n\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(b)\(b)\(s)\n\n"
    }

    static func letter5(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(s)\(s)\(s)\(s)\n\(s)\n\(s)\n\(s)\(s)\(s)\(s)\(s)\n\(b)\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(b)\(b)\(b)\(s)\n\(s)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letter6(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(s)\(s)\(s)\(s)\n\(s)\n\(s)\n\(s)\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letter7(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(s)\(s)\(s)\(s)\(s)\(s)\(s)\n\(b)\(b)\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(s)\n\(b)\(b)\(s)\n\(s)\n\n"
    }

    static func letter8(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(b)\(b)\(b)\(s)\n\(b)\(b)\(s)\(s)\n\(b)\(s)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(s)\(s)\(s)\n\n"
    }

    static func letter9(_ s: String) -> String {
        let b = getIsNumOrCharacter(s)
        return "\(b)\(s)\(s)\(s)\(s)\n\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\(s)\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(s)\(s)\(s)\n\(b)\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(b)\(b)\(b)\(b)\(b)\(s)\n\(b)\(s)\(s)\(s)\(s)\n\n"
    }
}
