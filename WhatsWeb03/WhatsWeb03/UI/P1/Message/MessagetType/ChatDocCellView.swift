//
//  ChatDocCellView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/29.
//

import SwiftUI
import UIKit

struct ChatDocCellView: View {
    let message: ChatMessageModel
    let pathName: String
    let isSelf: Bool

    private var parsedContent: String {
        if let range = message.content.range(of: "<") {
            return String(message.content[..<range.lowerBound])
        } else {
            return message.content
        }
    }

    private static let documentInteractionDelegate = DocumentInteractionDelegate()
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isSelf {
                Spacer()
                
                // 时间在左
                CustomText(
                    text: message.time,
                    fontName: Constants.FontString.medium,
                    fontSize: 10,
                    colorHex: "#AEAEAEFF"
                )
                .padding(.bottom, 2)
                
                CustomText(text: parsedContent, fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#101010FF")
                    .underline()
                    .padding(12)
                    .background(Color(hex: "#71FF89FF"))
                    .cornerRadius(10)

                
            } else {
                // 文档气泡
                CustomText(text: parsedContent, fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#101010FF")
                    .underline()
                    .padding(12)
                    .background(Color(hex: "#FFFFFFFF"))
                    .cornerRadius(10)
                
                // 时间在右
                CustomText(
                    text: message.time,
                    fontName: Constants.FontString.medium,
                    fontSize: 10,
                    colorHex: "#AEAEAEFF"
                )
                .padding(.bottom, 2)
                
                Spacer()
            }
        }
        .onTapGesture {
            let filePath = FileDefManager.getFileName(contentName: message.content, dicName: pathName)
            let fileURL = URL(fileURLWithPath: filePath)
            if (UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController) != nil {
                let docController = UIDocumentInteractionController(url: fileURL)
                docController.delegate = ChatDocCellView.documentInteractionDelegate
                docController.presentPreview(animated: true)
            }
        }
    }
}

class DocumentInteractionDelegate: NSObject, UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?.rootViewController ?? UIViewController()
    }
}
