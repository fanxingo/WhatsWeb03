//
//  SelectCountryView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/22.
//

import SwiftUI
import Kingfisher

struct SelectCountryView:View {
    
    var onComplete: (CountryModel) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @State private var searchString:String = ""
    @State private var countries: [CountryModel] = []
    
    private var filteredCountries: [CountryModel] {
        if searchString.isEmpty {
            return countries
        } else {
            return countries.filter { $0.name.lowercased().contains(searchString.lowercased()) }
        }
    }
    
    var body: some View {
        ZStack {
            VStack{
                TopView()
                SearchView()
                ListView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.white
        )
        .ignoresSafeArea(.keyboard)
        .dismissKeyboardOnTap()
        .onAppear {
            countries = CountryManager.assemblyData()
        }
    }
}
extension SelectCountryView{
    private func TopView() -> some View{
        VStack(spacing: 0){
            ZStack{
                HStack{
                    Button(action:{
                        dismiss()
                    }){
                        CustomText(text: "取消".localized(), fontName: Constants.FontString.semibold, fontSize: 16, colorHex: "#007AFFFF")
                    }
                    Spacer()
                }
                CustomText(text: "选择国家".localized(), fontName: Constants.FontString.semibold, fontSize: 17, colorHex: "#000000FF")
            }
            .padding(.horizontal,16)
            .frame(maxWidth: .infinity)
            .frame(height: 78)
            .background(
                Color(hex: "#F9F9F9F0")
            )
            Divider()
        }
    }
    private func SearchView() -> some View{
        HStack{
            Image("chat_icon4")
                .resizable()
                .scaledToFill()
                .frame(width: 20,height: 20)
            
            TextField("请输入".localized(), text: $searchString)
                .foregroundColor(Color(hex: "#101010FF"))
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal,16)
        .padding(.vertical,8)
        .background(
            Color(hex: "#EEEEEFFF")
        )
        .cornerRadius(10)
        .padding(.horizontal,16)
        .padding(.top,10)
    }
    private func ListView() -> some View{
        List{
            ForEach(filteredCountries, id: \.name) { item in
                CountryRowView(country: item, highlightText: searchString)
                    .onTapGesture {
                        dismiss()
                        onComplete(item)
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private struct CountryRowView: View {
        let country: CountryModel
        let highlightText: String
        var body: some View {
            VStack(alignment: .leading,spacing:0){
                HStack(alignment: .top,spacing: 16){
                    KFImage(URL(string: country.logo ?? ""))
                        .placeholder {
                            Color.clear
                                .frame(width: 25, height: 25)
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    HighlightedText(
                        text: country.name,
                        keyword: highlightText,
                        font: .custom(Constants.FontString.medium, size: 14),
                        normalColor: Color(hex: "#101010FF"),
                        highlightColor: Color(hex: "#00B81CFF")
                    )
                    Spacer()
                    CustomText(text: country.number!, fontName: Constants.FontString.medium, fontSize: 14, colorHex: "#000000FF")
                }
                .padding(.horizontal,16)
                .padding(.vertical,4)
                Divider()
                    .padding(.horizontal,16)
            }
            .listRowSeparator(.hidden, edges: .bottom)
        }
    }
}
