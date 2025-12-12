//
//  PayView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/12.
//

import SwiftUI

struct PayView : View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Image("payview_groundback")
                .resizable()
                .scaledToFill()
            VStack{
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image("back_image")
                            .resizable()
                            .frame(width: 55,height: 55)
                    }
                    Spacer()
                    Button(action:{
                        
                    }){
                        CustomText(text: "恢复".localized(), fontName: Constants.FontString.medium, fontSize: 12, colorHex: "#101010FF")
                    }
                }
                ZStack{
                    Image("payview_icon1")
                        .resizable()
                        .scaledToFit()
                    GradientText(
                        text: "Unlock all Features".localized(),
                        colors: [Color(hex: "#00D125FF"), Color(hex: "#09AEFDFF")],
                        font: .custom(Constants.FontString.semibold, size: 20),
                        starPoint: .top,
                        endPoint: .bottom
                    )
                    .padding(.horizontal,30)
                }
                .frame(width: 234,height: 70)
                .padding(.top,20)
                
                Spacer()
            }
            .padding(.top,safeTop)
            .padding(.horizontal,16)
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    PayView()
}
