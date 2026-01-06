//
//  UserIconView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/25.
//

import SwiftUI

struct UserIconView : View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navManager: NavigationManager
    
    var body: some View {
        ZStack {
            ScrollView {
                let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 3)

                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(1...36, id: \.self) { index in
                        let iconName = "user_icon\(index)"

                        Button(action:{
                            navManager.path.append(AppRoute.selectedIconView(iconName: iconName))
                        }){
                            Image(iconName)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding(.horizontal, 4)
                .padding(.top, 4)
            }
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationModifiers(title: "Social avatars".localized(), onBack: {
            dismiss()
        })
    }
}

struct SelectedIconView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let iconName: String
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 中间可缩放图片区域
                ZoomableImageView(
                    iconName: iconName,
                    containerSize: geo.size
                )

                // 底部按钮
                VStack {
                    Spacer()

                    Button(action: {
                        if let uiImage = UIImage(named: iconName) {
                            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                            ToastManager.shared.showToast(message: "Saved to album".localized())
                        }
                    }) {
                        Text("Download".localized())
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                            .frame(width: 130, height: 36)
                            .background(Color(hex: "#00B81CFF"))
                            .cornerRadius(20)
                    }
                    .padding(.bottom,20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationModifiers(title: "", onBack: {
            dismiss()
        })
    }
}

struct ZoomableImageView: View {

    let iconName: String
    let containerSize: CGSize

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.clear

            Image(iconName)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .offset(offset)
            
        }
        .frame(
            width: containerSize.width,
            height: containerSize.height,
            alignment: .center
        )
        .clipped()
        .gesture(
            SimultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        let newScale = lastScale * value
                        scale = min(max(newScale, 1.0), 2.0)

                        if scale == 1.0 {
                            offset = .zero
                            lastOffset = .zero
                        } else {
                            let maxOffsetX = (containerSize.width * (scale - 1)) / 2
                            let maxOffsetY = (containerSize.height * (scale - 1)) / 2
                            offset.width = min(max(offset.width, -maxOffsetX), maxOffsetX)
                            offset.height = min(max(offset.height, -maxOffsetY), maxOffsetY)
                            lastOffset = offset
                        }
                    }
                    .onEnded { _ in
                        lastScale = scale
                    },
                DragGesture()
                    .onChanged { value in
                        guard scale > 1.0 else { return }
                        
                        var newOffset = CGSize(
                            width: lastOffset.width + value.translation.width,
                            height: lastOffset.height + value.translation.height
                        )
                        
                        let maxOffsetX = (containerSize.width * (scale - 1)) / 2
                        let maxOffsetY = (containerSize.height * (scale - 1)) / 2
                        
                        newOffset.width = min(max(newOffset.width, -maxOffsetX), maxOffsetX)
                        newOffset.height = min(max(newOffset.height, -maxOffsetY), maxOffsetY)
                        
                        offset = newOffset
                    }
                    .onEnded { _ in
                        guard scale > 1.0 else { return }
                        lastOffset = offset
                    }
            )
        )
        .animation(.easeInOut(duration: 0.2), value: scale)
    }
}
