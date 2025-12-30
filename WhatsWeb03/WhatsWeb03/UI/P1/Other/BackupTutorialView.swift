//
//  BackupTutorialView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/16.
//

import SwiftUI

struct BackupTutorialView:View {
    
    @Environment(\.dismiss) var dismiss
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            let item = tutorialItem[currentIndex]

            VStack(spacing: 0) {
                Image(item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.top,80)

                HStack(spacing: 4) {
                    ForEach(0..<tutorialItem.count, id: \.self) { index in
                        if index == currentIndex {
                            LinearGradient(
                                colors: [Color(hex: "#3CFF5EFF"), Color(hex: "#57C8FFFF")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(width: 10, height: 4)
                            .cornerRadius(2)
                        } else {
                            Circle()
                                .fill(Color(hex: "#D9D9D9FF"))
                                .frame(width: 4, height: 4)
                        }
                    }
                }
                .padding(.top,20)

                CustomText(text: item.title, fontName: Constants.FontString.semibold, fontSize: 18, colorHex: "#00B81CFF")
                    .padding(.top,30)

                composedDescView(desc: item.desc, cDesc: item.cDesc)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top,10)

                Spacer()

                Button(action: {
                    if currentIndex < tutorialItem.count - 1 {
                        currentIndex += 1
                    } else {
                        dismiss()
                    }
                }) {
                    Text(currentIndex < tutorialItem.count - 1 ? "Next".localized() : "Complete".localized())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#00B81CFF"))
                        .foregroundColor(.white)
                        .font(.custom(Constants.FontString.semibold, size: 14))
                        .cornerRadius(30)
                }
                .frame(width: 220)
                .padding(.bottom,safeBottom + 16)
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .navigationModifiers(title: "Backup Tutorial".localized()) {
            dismiss()
        }
    }
}

private func composedDescView(desc: String, cDesc: String) -> some View {
    let components = desc.components(separatedBy: cDesc)
    var text = Text("")
    for (index, part) in components.enumerated() {
        text = text + Text(part).foregroundColor(Color(hex: "#101010FF"))
        if index < components.count - 1 {
            text = text + Text(cDesc).foregroundColor(Color(hex: "#00B81CFF"))
        }
    }
    return text
        .font(.custom(Constants.FontString.medium, size: 16))
}


private struct BackupTutorialItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let desc: String
    let cDesc: String
}

private let tutorialItem: [BackupTutorialItem] = [
    BackupTutorialItem(icon: "message_tips1", title: "Step 1".localized(), desc: "Choose Your Chat Software & Find The %@".localized("Chat Interface".localized()),cDesc: "Chat Interface".localized()),
    BackupTutorialItem(icon: "message_tips2", title: "Step 2".localized(), desc: "Open Chat & %@".localized("Click on Profile".localized()),cDesc: "Click on Profile".localized()),
    BackupTutorialItem(icon: "message_tips3", title: "Step 3".localized(), desc: "Choose %@".localized("Exprort Chat".localized()),cDesc: "Exprort Chat".localized()),
    BackupTutorialItem(icon: "message_tips4", title: "Step 4".localized(), desc: "Choose %@".localized("Attach Media".localized()),cDesc: "Attach Media".localized()),
    BackupTutorialItem(icon: "message_tips5", title: "Step 5".localized(), desc: "Find %@ & Click On It".localized("Dual WAMR".localized()),cDesc: "Dual WAMR".localized()),
]
