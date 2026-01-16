//
//  UUIDTool.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2026/1/6.
//

import Foundation
import Security

final class UUIDTool {
    
    private static let kUUIDKey = "XXXXXXXXXXXXXXX123"
    
    /// 获取一个新的UUID字符串（非持久化）
    static func getUUID() -> String {
        return UUID().uuidString
    }
    
    /// 从Keychain读取UUID，如果没有则生成、保存并返回
    static func getUUIDInKeychain() -> String {
        if let uuid = load(service: kUUIDKey), !uuid.isEmpty {
            print("从Keychain获取UUID: \(uuid)")
            return uuid
        }
        
        let newUUID = UUID().uuidString
        print("生成新的UUID: \(newUUID)")
        save(service: kUUIDKey, data: newUUID)
        return newUUID
    }
    
    /// 删除Keychain中保存的UUID
    static func deleteKeychain() {
        delete(service: kUUIDKey)
    }
    
    // MARK: - Keychain 操作
    
    private static func getKeychainQuery(service: String) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: service,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
    }
    
    private static func save(service: String, data: String) {
        var query = getKeychainQuery(service: service)
        // 先删除旧数据
        SecItemDelete(query as CFDictionary)
        
        // 保存新数据
        if let data = data.data(using: .utf8) {
            query[kSecValueData as String] = data
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("保存到Keychain失败，错误码: \(status)")
            }
        }
    }
    
    private static func load(service: String) -> String? {
        var query = getKeychainQuery(service: service)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data,
               let result = String(data: data, encoding: .utf8) {
                return result
            }
        } else {
            print("从Keychain加载失败，错误码: \(status)")
        }
        
        return nil
    }
    
    private static func delete(service: String) {
        let query = getKeychainQuery(service: service)
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("从Keychain删除失败，错误码: \(status)")
        }
    }
}
