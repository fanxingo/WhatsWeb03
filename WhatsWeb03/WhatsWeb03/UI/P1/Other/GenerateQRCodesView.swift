//
//  GenerateQRCodesView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

struct GenerateQRCodesView : View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var inputString : String = ""
    @State private var qrCodeImage: UIImage? = nil
    
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    struct QRCodeActionButton: View {
        let imageName: String
        let text: String
        let colorHex: String
        
        var body: some View {
            VStack(spacing: 4) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                CustomText(text: text,
                           fontName: Constants.FontString.medium,
                           fontSize: 12,
                           colorHex: colorHex)
            }
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        
        guard let outputImage = filter.outputImage else { return nil }
        
        let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        
        if let cgimg = context.createCGImage(transformedImage, from: transformedImage.extent) {
            return UIImage(cgImage: cgimg)
        }
        return nil
    }
    
    private func copyQRCodeToClipboard() {
        if let image = qrCodeImage {
            UIPasteboard.general.image = image
        }
    }
    
    private func saveQRCodeToPhotos() {
        guard let image = qrCodeImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                BorderedTextEditor(text: $inputString,
                                   placeholder: "编辑您需要的文本".localized(),
                                   cornerRadius: 20,
                                   minHeight: 150,
                                   maxHeight: 150)
                
                Button(action: {
                    if !inputString.isEmpty {
                        qrCodeImage = generateQRCode(from: inputString)
                    } else {
                        qrCodeImage = nil
                    }
                }) {
                    CustomText(text: "生成".localized(),
                               fontName: Constants.FontString.semibold,
                               fontSize: 14,
                               colorHex: "#FFFFFFFF")
                        .frame(maxWidth: 300, maxHeight: 44)
                        .background(Color(hex: "#00B81CFF"))
                        .cornerRadius(22)
                }
                
                if let qrImage = qrCodeImage {
                    Image(uiImage: qrImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 254, height: 254)
                        .padding(.top,30)
                } else {
                    Spacer().frame(height: 254 + 30)
                }
                
                Spacer()
                
                HStack(spacing: 0) {
                    Spacer()
                    Button(action: {
                        inputString = ""
                        qrCodeImage = nil
                    }) {
                        QRCodeActionButton(imageName: "code_icon1",
                                           text: "删除".localized(),
                                           colorHex: "#FF4545FF")
                    }
                    Spacer()
                    Button(action: {
                        copyQRCodeToClipboard()
                        ToastManager.shared.showToast(message: "复制成功".localized())
                    }) {
                        QRCodeActionButton(imageName: "code_icon2",
                                           text: "复制".localized(),
                                           colorHex: "#00B81CFF")
                    }
                    Spacer()
                    Button(action: {
                        saveQRCodeToPhotos()
                        ToastManager.shared.showToast(message: "保存成功".localized())
                    }) {
                        QRCodeActionButton(imageName: "code_icon3",
                                           text: "保存".localized(),
                                           colorHex: "#00AEFFFF")
                    }
                    Spacer()
                }
                .safeAreaPadding(.bottom)
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 16)
            .padding(.top,16)
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationModifiers(title: "Generate QR Codes".localized(), onBack: {
            dismiss()
        })
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
    }
}

#Preview {
    GenerateQRCodesView()
}
