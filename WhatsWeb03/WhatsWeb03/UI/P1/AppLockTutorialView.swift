//
//  A.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/16.
//

import SwiftUI

struct AppLockTutorialView:View {
    
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

                CustomText(text: item.desc, fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#101010FF")
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
        .navigationModifiers(title: "Combination Lock Usage".localized()) {
            dismiss()
        }
    }
}

private struct AppLockTutorialItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let desc: String
}

private let tutorialItem: [AppLockTutorialItem] = [
    AppLockTutorialItem(icon: "applock_tips1", title: "Step 1".localized(), desc: "点击开启使用密码，设置新密码".localized()),
    AppLockTutorialItem(icon: "applock_tips2", title: "Step 2".localized(), desc: "开启使用密码，点击双信使或者消息备份，需要输入正确密码".localized()),
    AppLockTutorialItem(icon: "applock_tips3", title: "Step 3".localized(), desc: "需要关闭，点击关闭密码锁".localized())
]
