//
//  PopView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/15.
//

import SwiftUI



struct DeletePopView: View {
    
    var title:String
    var subString:String = "确定".localized()
    var cancelString:String = "取消".localized()
    var onComplete: () -> Void
    
    var body: some View {
        ZStack(alignment: .center){
            Color(hex: "#29293A33")
            ZStack{
                VStack(spacing:18){
                    CustomText(text: title, fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#000000FF")
                    HStack(){
                        Button(action:{
                            PopManager.shared.dismiss()
                        }){
                            CustomText(
                                text: cancelString,
                                fontName: Constants.FontString.medium,
                                fontSize: 17,
                                colorHex: "#000000FF"
                            )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 13)
                                .background(
                                    Color(hex: "#78788029")
                                )
                                .cornerRadius(24)
                        }
                        Spacer()
                        Button(action:{
                            onComplete()
                            PopManager.shared.dismiss()
                        }){
                            CustomText(
                                text: subString,
                                fontName: Constants.FontString.medium,
                                fontSize: 17,
                                colorHex: "#FFFFFFFF"
                            )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 13)
                                .background(
                                    Color(hex: "#00B81CFF")
                                )
                                .cornerRadius(24)
                        }
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: 300)
            .background(
                Image("pop_ground_image")
                    .resizable(capInsets: EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
                    .cornerRadius(34)
                    .opacity(0.95)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    DeletePopView(title: "确认是否删除“WhatsApp”？") {
        
    }
}
