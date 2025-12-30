//
//  Untitled.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/22.
//

import Foundation

struct CountryModel: Identifiable {
    let id = UUID()
    
    /// ISO 3166-1 alpha-2（US、CN 等）
    let cca2: String
    
    /// 国家名称（本地化）
    let name: String
    
    /// 国家区号（如 +86）
    let number: String?
    
    /// 国旗图片 URL（png）
    let logo: String?
}

final class CountryManager {
    
    /// 组装国家数据
    static func assemblyData() -> [CountryModel] {
        
        var countries: [String: CountryModel] = [:]
        
        let locale = Locale.current
        let countryCodes = Locale.Region.isoRegions.map { $0.identifier }
        
        // 1️⃣ 先生成基础国家列表（code + name）
        for code in countryCodes {
            let name = locale.localizedString(forRegionCode: code) ?? code
            countries[code] = CountryModel(
                cca2: code,
                name: name,
                number: nil,
                logo: nil
            )
        }
        
        // 2️⃣ 读取本地 countryFile.txt
        guard
            let path = Bundle.main.path(forResource: "countryFile", ofType: "txt"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        else {
            return []
        }
        
        for dict in jsonArray {
            guard let cca2 = dict["cca2"] as? String else { continue }
            
            // 区号
            var number: String?
            if
                let idd = dict["idd"] as? [String: Any],
                let root = idd["root"] as? String,
                let suffixes = idd["suffixes"] as? [String],
                let first = suffixes.first
            {
                number = root + first
            }
            
            // 国旗
            var logo: String?
            if
                let flags = dict["flags"] as? [String: Any],
                let png = flags["png"] as? String
            {
                logo = png
            }
            
            if let old = countries[cca2], let number {
                countries[cca2] = CountryModel(
                    cca2: old.cca2,
                    name: old.name,
                    number: number,
                    logo: logo
                )
            }
        }
        
        // 3️⃣ 只保留有区号的数据
        return countries.values
            .filter { $0.number?.isEmpty == false }
            .sorted { $0.name < $1.name }
    }
    
    /// 获取默认国家（基于系统地区）
    static func getDefaultCountry() -> CountryModel? {
        let currentCode = Locale.current.region?.identifier

        return assemblyData()
            .first { $0.cca2 == currentCode }
    }
}
