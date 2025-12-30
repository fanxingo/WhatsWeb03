//
//  RemindView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/25.
//

import SwiftUI

struct RemindView:View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var navManager: NavigationManager
    
    @State private var items: [ItemModel] = []

    @State private var isEdit: Bool = false
    
    var body: some View {
        ZStack{
            if items.isEmpty {
                NoDataView()
            } else {
                List {
                    ForEach(items) { item in
                        ZStack(alignment: .topTrailing){
                            VStack{
                                CustomText(text: item.title,
                                           fontName: Constants.FontString.medium,
                                           fontSize: 12,
                                           colorHex: "#101010FF")
                                .frame(maxWidth: .infinity,alignment: .leading)
                                CustomText(text: item.content,
                                           fontName: Constants.FontString.medium,
                                           fontSize: 10,
                                           colorHex: "#7D7D7DFF")
                                .frame(maxWidth: .infinity,alignment: .leading)
                                Divider()
                                
                                CustomText(text: DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .none) + "  " + item.time, fontName: Constants.FontString.regular, fontSize: 12, colorHex: "#7D7D7DFF")
                                    .frame(maxWidth: .infinity,alignment: .leading)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "#F1F1F1FF"), lineWidth: 1))
                            .padding(.top,10)
                            .onTapGesture {
                                navManager.path.append(AppRoute.createRemindView(itemID: item.id))
                            }
                            
                            if isEdit{
                                Image("chat_icon6")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20,height: 20)
                                    .onTapGesture {
                                        PopManager.shared.show(DeletePopView(title: "确认是否删除", onComplete: {
                                            PlistManager.shared.removeItem(by: item.id)
                                            items.removeAll { $0.id == item.id }
                                            if items.isEmpty {
                                                isEdit = false
                                            }
                                            ToastManager.shared.showToast(message: "删除成功".localized())
                                        }))
                                    }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    Color.clear
                        .frame(height: 80)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                
                VStack{
                    Spacer()
                    Button(action:{
                        navManager.path.append(AppRoute.createRemindView(itemID: nil))
                    }){
                        CustomText(text: "Create Schedule".localized(),
                                   fontName: Constants.FontString.semibold,
                                   fontSize: 14,
                                   colorHex: "#FFFFFFFF")
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                            .background(Color(hex: "#00B81CFF"))
                            .cornerRadius(20)
                    }
                }
                .safeAreaPadding(.bottom)
            }
        }
        .onAppear {
            items = PlistManager.shared.loadItems()
        }
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationModifiersWithRightView(title: "Schedule reminders".localized(), onBack: {
            dismiss()
        }, rightView: {
            if !items.isEmpty {
                Button(action:{
                    isEdit.toggle()
                }){
                    CustomText(text: isEdit ? "Cancel".localized() : "Edit".localized(),
                               fontName: Constants.FontString.semibold,
                               fontSize: 14,
                               colorHex: "#FF4545FF")
                }
            }else{
                EmptyView()
            }
        })
    }
}
extension RemindView{
    
    private func NoDataView() -> some View{
        VStack(spacing:16){
            Image("remind_icon1")
                .resizable()
                .scaledToFit()
                .frame(width: 236,height: 139)
            CustomText(text: "There are Currently No Schedule Reminders", fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#AEAEAEFF")
                .padding(.horizontal,60)
                .multilineTextAlignment(.center)
            
            Button(action: {
                navManager.path.append(AppRoute.createRemindView(itemID: nil))
            }) {
                CustomText(text: "Create Schedule".localized(),
                           fontName: Constants.FontString.semibold,
                           fontSize: 14,
                           colorHex: "#FFFFFFFF")
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(Color(hex: "#00B81CFF"))
                    .cornerRadius(20)
            }
        }
    }
}

