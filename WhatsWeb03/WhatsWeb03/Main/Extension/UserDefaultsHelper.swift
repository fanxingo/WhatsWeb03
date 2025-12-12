//
//  UserDefaultsHelper.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//
import Foundation

struct UserDefaultsHelper {
    
    // 写入
    static func set<T: Encodable>(_ value: T, forKey key: String) {
        if let value = value as? String {
            UserDefaults.standard.set(value, forKey: key)
        } else if let value = value as? Int {
            UserDefaults.standard.set(value, forKey: key)
        } else if let value = value as? Double {
            UserDefaults.standard.set(value, forKey: key)
        } else if let value = value as? Bool {
            UserDefaults.standard.set(value, forKey: key)
        } else if let value = value as? Data {
            UserDefaults.standard.set(value, forKey: key)
        } else {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(value) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
    
    // 读取
    static func get<T: Decodable>(forKey key: String, as type: T.Type) -> T? {
        if type == String.self {
            return UserDefaults.standard.string(forKey: key) as? T
        } else if type == Int.self {
            return UserDefaults.standard.integer(forKey: key) as? T
        } else if type == Double.self {
            return UserDefaults.standard.double(forKey: key) as? T
        } else if type == Bool.self {
            return UserDefaults.standard.bool(forKey: key) as? T
        } else if type == Data.self {
            return UserDefaults.standard.data(forKey: key) as? T
        } else {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return nil
            }
            let decoder = JSONDecoder()
            return try? decoder.decode(type, from: data)
        }
    }

    // 删除
    static func remove(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
