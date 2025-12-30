//
//  CreateRemindView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/25.
//

import SwiftUI

struct CreateRemindView: View {
    let itemID: UUID?

    @Environment(\.dismiss) var dismiss

    @State private var inputTitle: String = ""
    @State private var inputDesc: String = ""

    @State private var selectDate: Date? = nil
    @State private var selectTime: String = ""
    @State private var isRemind: Bool = false

    @State private var openDate: Bool = false
    @State private var openTime: Bool = false

    @State private var isEditing: Bool = false

    init(itemID: UUID? = nil) {
        self.itemID = itemID
    }

    var body: some View {
        ZStack(alignment:.bottom){
            ScrollView{
                VStack(spacing: 16){
                    InputView()
                    SelectDateView()
                        .onTapGesture {
                            openDate.toggle()
                        }
                    SelectTimeView(selectedTime: $selectTime)
                        .onTapGesture {
                            openTime.toggle()
                        }
                    SelectToggle()
                }
                Color.clear
                    .frame(height: 100)
            }
            .scrollIndicators(.hidden)
            
            if !isEditing {
                Button(action: {
                    if inputTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        ToastManager.shared.showToast(message: "Title cannot be empty.".localized())
                        return
                    }
                    if inputDesc.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        ToastManager.shared.showToast(message: "Content cannot be empty.".localized())
                        return
                    }
                    guard let date = selectDate else {
                        ToastManager.shared.showToast(message: "Please select a date.".localized())
                        return
                    }
                    if selectTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        ToastManager.shared.showToast(message: "Please select a time.".localized())
                        return
                    }
                    
                    let newItem = ItemModel(id: UUID(),
                                            title: inputTitle,
                                            content: inputDesc,
                                            date: date,
                                            time: selectTime,
                                            isReminder: isRemind)
                    PlistManager.shared.addItem(newItem)
                    dismiss()
                }) {
                    CustomText(text: "Add to".localized(),
                               fontName: Constants.FontString.semibold,
                               fontSize: 14,
                               colorHex: "#FFFFFFFF")
                        .frame(maxWidth: 300, maxHeight: 44)
                        .background(Color(hex: "#00B81CFF"))
                        .cornerRadius(22)
                }
                .safeAreaPadding(.bottom,20)
            } else {
                HStack(spacing: 20) {
                    Button(action: {
                        if let id = itemID {
                            PopManager.shared.show(DeletePopView(title: "确认是否删除", onComplete: {
                                PlistManager.shared.removeItem(by: id)
                                dismiss()
                                ToastManager.shared.showToast(message: "删除成功".localized())
                            }))
                        }

                    }) {
                        CustomText(text: "Delete".localized(),
                                   fontName: Constants.FontString.semibold,
                                   fontSize: 14,
                                   colorHex: "#FFFFFFFF")
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .background(Color(hex: "#FF4545FF"))
                            .cornerRadius(22)
                    }
                    Button(action: {
                        if inputTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            ToastManager.shared.showToast(message: "Title cannot be empty.".localized())
                            return
                        }
                        if inputDesc.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            ToastManager.shared.showToast(message: "Content cannot be empty.".localized())
                            return
                        }
                        guard let date = selectDate else {
                            ToastManager.shared.showToast(message: "Please select a date.".localized())
                            return
                        }
                        if selectTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            ToastManager.shared.showToast(message: "Please select a time.".localized())
                            return
                        }
                        if let id = itemID {
                            let updatedItem = ItemModel(id: id,
                                                        title: inputTitle,
                                                        content: inputDesc,
                                                        date: date,
                                                        time: selectTime,
                                                        isReminder: isRemind)
                            PlistManager.shared.updateItem(updatedItem)
                        }
                        dismiss()
                    }) {
                        CustomText(text: "Save".localized(),
                                   fontName: Constants.FontString.semibold,
                                   fontSize: 14,
                                   colorHex: "#FFFFFFFF")
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .background(Color(hex: "#00B81CFF"))
                            .cornerRadius(22)
                    }
                }
                .padding(.horizontal, 16)
                .safeAreaPadding(.bottom, 20)
            }
        }
        .safeAreaPadding(.top)
        .padding(.horizontal,16)
        .fullScreenColorBackground("#FBFFFCFF", false)
        .navigationModifiers(
            title: isEditing ? "Schedule".localized() : "New Schedule".localized(),
            onBack: {
                dismiss()
            }
        )
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
        .onAppear {
            // 如果 itemID 不为空，查询数据并赋值
            if let id = itemID {
                if let item = PlistManager.shared.getItem(by: id) {
                    inputTitle = item.title
                    inputDesc = item.content
                    selectDate = item.date
                    selectTime = item.time
                    isRemind = item.isReminder
                    isEditing = true
                }
            }
        }
    }
}

extension CreateRemindView{
    
    private func InputView() -> some View{
        VStack(spacing: 0){
            
            TextField("标题".localized(), text: $inputTitle)
                .font(.custom(Constants.FontString.medium, size: 14))
                .padding(EdgeInsets(top: 12, leading: 14, bottom: 10, trailing: 14))
            Divider()
                .padding(.horizontal,10)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $inputDesc)
                    .font(.custom(Constants.FontString.medium, size: 14))
                    .foregroundColor(.black)
                    .frame(minHeight: 160, maxHeight: 160)
                    .padding(8)
                if inputDesc.isEmpty {
                    Text("信息内容".localized())
                        .font(.custom(Constants.FontString.medium, size: 14))
                        .foregroundColor(Color(hex: "#BABDBD"))
                        .allowsHitTesting(false)
                        .padding(EdgeInsets(top: 14, leading: 14, bottom: 0, trailing: 14))
                }
            }
        }
        .background(
            whiteRoundedBorder()
        )
    }
    
    private func SelectDateView() -> some View{
        VStack(spacing:0){
            itemRow(
                icon: "remind_icon2",
                title: "日期".localized(),
                rightView:
                    CustomText(
                        text: selectDate.map {
                            let formatter = DateFormatter()
                            formatter.locale = Locale.current
                            formatter.dateFormat = "EEEE, MMMM dd, yyyy"
                            return formatter.string(from: $0)
                        } ?? "",
                        fontName: Constants.FontString.medium,
                        fontSize: 14,
                        colorHex: "#00B81CFF"
                    )
            )
            
            if openDate {
                Divider()
                    .padding(.horizontal,12)
    
                MonthCalendarView(selectedDate: $selectDate)
                    .padding(12)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            whiteRoundedBorder()
        )
    }
    
    private func SelectTimeView(selectedTime: Binding<String>) -> some View {
        VStack(spacing:0){
            itemRow(
                icon: "remind_icon3",
                title: "时间".localized(),
                rightView:
                    CustomText(
                        text: selectedTime.wrappedValue,
                        fontName: Constants.FontString.medium,
                        fontSize: 14,
                        colorHex: "#00B81CFF"
                    )
            )
            
            if openTime {
                Divider()
                    .padding(.horizontal,12)
                CustomTimePicker(selectedTime: selectedTime)
                        .frame(height: 130)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            whiteRoundedBorder()
        )
    }
    
    private func SelectToggle() -> some View{
        VStack{
            itemRow(
                icon: "remind_icon4",
                title: "提醒".localized(),
                rightView:
                    Toggle("", isOn: $isRemind)
            )
        }
        .frame(maxWidth: .infinity)
        .background(
            whiteRoundedBorder()
        )
    }
    

    private func itemRow<RightView: View>(
        icon: String,
        title: String,
        rightView: RightView
    ) -> some View {
        HStack(spacing: 10) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)

            CustomText(
                text: title.localized(),
                fontName: Constants.FontString.medium,
                fontSize: 14,
                colorHex: "#101010FF"
            )

            Spacer()

            rightView
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
    }
    
    
    private func whiteRoundedBorder(
        cornerRadius: CGFloat = 12,
        borderColor: Color = Color(hex: "#BABDBD"),
        lineWidth: CGFloat = 1
    ) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}
