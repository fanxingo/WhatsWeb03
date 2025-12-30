//
//  MonthCalendarView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/25.
//

import SwiftUI

struct MonthCalendarView: View {

    @Binding var selectedDate: Date?
    @State private var displayMonth: Date = Date()

    private let calendar = Calendar.current
    private let weekSymbols = Calendar.current.shortWeekdaySymbols

    var body: some View {
        VStack(spacing:8) {
            HStack(spacing:28){
                Text(monthTitle)
                    .font(.custom(Constants.FontString.medium, size: 14))
                Spacer()
                Button(action: { changeMonth(-1) }) {
                    Image("remind_icon5")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Button(action: { changeMonth(1) }) {
                    Image("remind_icon6")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal,12)

            HStack {
                ForEach(weekSymbols, id: \.self) {
                    Text($0)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top,8)
            .padding(.horizontal,12)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    dayCell(date)
                }
            }
            .padding(.horizontal,12)
        }
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayMonth)
    }

    private var daysInMonth: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: displayMonth),
            let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else { return [] }

        return (0..<42).compactMap {
            calendar.date(byAdding: .day, value: $0, to: firstWeek.start)
        }
    }

    private func dayCell(_ date: Date) -> some View {
        let isCurrentMonth = calendar.isDate(date, equalTo: displayMonth, toGranularity: .month)
        let isSelected = selectedDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false
        let isToday = calendar.isDateInToday(date)

        return Text("\(calendar.component(.day, from: date))")
            .font(.system(size: 12))
            .frame(maxWidth: .infinity, minHeight: 25)
            .foregroundColor(
                isSelected ? .white :
                isToday ? Color(hex: "#00B81CFF") :
                isCurrentMonth ? .black : .gray
            )
            .background(
                Circle()
                    .fill(isSelected ? Color(hex: "#00B81CFF") : .clear)
            )
            .onTapGesture {
                selectedDate = date
            }
    }

    private func changeMonth(_ value: Int) {
        displayMonth = calendar.date(byAdding: .month, value: value, to: displayMonth) ?? displayMonth
    }
}
