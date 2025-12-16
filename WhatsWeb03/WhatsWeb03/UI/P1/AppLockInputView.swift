//
//  AppLockInputView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/16.
//

import SwiftUI

struct AppLockInputView : View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Image("payview_groundback")
                .resizable()
                .scaledToFill()
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    AppLockInputView()
}
