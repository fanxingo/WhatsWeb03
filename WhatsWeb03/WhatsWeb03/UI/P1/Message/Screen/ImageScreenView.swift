//
//  ImageScreenView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/29.
//
import SwiftUI
import Kingfisher

struct ImageScreenView: View {

    @Environment(\.dismiss) var dismiss
    

    
    let selectModel: ChatMessageModel
    let items: [ChatMessageModel]
    let pathName: String
    
    var onComplete: (() -> Void)? = nil

    @State private var selectedIndex: Int

    init(selectModel: ChatMessageModel, items: [ChatMessageModel], pathName: String,onComplete: (() -> Void)? = nil) {
        self.selectModel = selectModel
        self.items = items
        self.pathName = pathName
        self.onComplete = onComplete
        
        if let idx = items.firstIndex(where: { $0.id == selectModel.id }) {
            _selectedIndex = State(initialValue: idx)
        } else {
            _selectedIndex = State(initialValue: 0)
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // 顶部导航
            HStack {
                Button(action: { dismiss() }) {
                    Image("select_view_icon1")
                        .resizable()
                        .frame(width: 34, height: 34)
                }
                Spacer()
                CustomText(
                    text: items[selectedIndex].time,
                    fontName: Constants.FontString.medium,
                    fontSize: 16,
                    colorHex: "#FFFFFF"
                )
                Spacer()
                Button(action: {

                    let filePath = FileDefManager.getFileName(contentName: items[selectedIndex].content, dicName: pathName)
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                       let image = UIImage(data: data),
                       let pngData = image.pngData(),
                       let pngImage = UIImage(data: pngData) {
                        UIImageWriteToSavedPhotosAlbum(pngImage, nil, nil, nil)
                        ToastManager.shared.showToast(message: "已保存到相册".localized())
                    } else {
                        ToastManager.shared.showToast(message: "保存失败".localized())
                    }
                    
                }) {
                    Image("select_view_icon2")
                        .resizable()
                        .frame(width: 34, height: 34)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 54)

            // 中间大图分页
            ImagePagerView(selectedIndex: $selectedIndex, items: items, pathName: pathName)

            HStack{
                Spacer()
                Button(action: {
                    onComplete?()
                }) {
                    Image("select_view_icon3")
                        .resizable()
                        .frame(width: 34, height: 34)
                }
            }
            .padding(.horizontal,16)
            // 底部缩略图
            ThumbnailScrollView(selectedIndex: $selectedIndex, items: items, pathName: pathName)

            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .modifier(ToastModifier())
    }
}

struct ImagePagerView: View {
    @Binding var selectedIndex: Int
    let items: [ChatMessageModel]
    let pathName: String
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(items.indices, id: \.self) { idx in
                let model = items[idx]
                let filePath = FileDefManager.getFileName(contentName: model.content, dicName: pathName)

                KFImage(URL(fileURLWithPath: filePath))
                    .placeholder {
                        Image("loding_bgimage")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    }
                    .resizable()
                    .scaledToFit()
                    .tag(idx)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

struct ThumbnailScrollView: View {
    @Binding var selectedIndex: Int
    let items: [ChatMessageModel]
    let pathName: String

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(items.indices, id: \.self) { idx in
                        let model = items[idx]
                        let filePath = FileDefManager.getFileName(contentName: model.content, dicName: pathName)
                        let isSelected = selectedIndex == idx
                        let size: CGFloat = isSelected ? 45 : 30
                        KFImage(URL(fileURLWithPath: filePath))
                            .placeholder {
                                Image("loding_bgimage")
                                    .resizable()
                                    .frame(width: size, height: size)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                            )
                            .id(idx)
                            .onTapGesture {
                                withAnimation {
                                    selectedIndex = idx
                                }
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 45)
            .onChange(of: selectedIndex) {oldIdx, idx in
                withAnimation {
                    proxy.scrollTo(idx, anchor: .center)
                }
            }
        }
    }
}
