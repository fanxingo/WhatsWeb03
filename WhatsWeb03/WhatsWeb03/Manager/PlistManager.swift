//
//  PlistManager.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/25.
//

import Foundation
import UserNotifications

struct ItemModel: Codable, Identifiable {
    var id: UUID
    var title: String
    var content: String
    var date: Date
    var time: String
    var isReminder: Bool
}

class PlistManager {
    static let shared = PlistManager()
    
    private let fileName = "ItemList.plist"
    private var fileURL: URL {
        let manager = FileManager.default
        let docURL = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docURL.appendingPathComponent(fileName)
    }
    
    private init() {
        // 如果 plist 不存在，则创建空数组
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            saveItems([])
        }
    }
    
    // MARK: - CRUD 操作
    
    func loadItems() -> [ItemModel] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        let decoder = PropertyListDecoder()
        if let items = try? decoder.decode([ItemModel].self, from: data) {
            return items
        }
        return []
    }
    
    @discardableResult
    func saveItems(_ items: [ItemModel]) -> Bool {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let data = try encoder.encode(items)
            try data.write(to: fileURL)
            return true
        } catch {
            print("Plist 保存失败: \(error)")
            return false
        }
    }
    
    func addItem(_ item: ItemModel) {
        var items = loadItems()
        items.append(item)
        requestNotificationPermissionIfNeeded { granted in
            if item.isReminder {
                self.scheduleNotification(for: item)
            }
        }
        saveItems(items)
    }
    
    func updateItem(_ item: ItemModel) {
        var items = loadItems()
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            // 先删除原有通知
            removeNotification(for: items[index])
            items[index] = item
            requestNotificationPermissionIfNeeded { granted in
                if item.isReminder {
                    self.scheduleNotification(for: item)
                }
            }
            saveItems(items)
        }
    }
    
    func removeItem(by id: UUID) {
        var items = loadItems()
        if let item = items.first(where: { $0.id == id }) {
            removeNotification(for: item)
        }
        items.removeAll { $0.id == id }
        saveItems(items)
    }
    
    func removeAllItems() {
        // 删除所有通知
        let items = loadItems()
        for item in items {
            removeNotification(for: item)
        }
        saveItems([])
    }
    
    func getItem(by id: UUID) -> ItemModel? {
        let items = loadItems()
        return items.first { $0.id == id }
    }
}

// MARK: - 通知相关
extension PlistManager {
    private func requestNotificationPermissionIfNeeded(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                completion(true)
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    completion(granted)
                }
            default:
                completion(false)
            }
        }
    }

    private func scheduleNotification(for item: ItemModel) {
        let content = UNMutableNotificationContent()
        content.title = item.title
        content.body = item.content
        content.sound = .default

        // 解析时间字符串 "HH:mm"
        let timeComponents = item.time.split(separator: ":").compactMap { Int($0) }
        guard timeComponents.count == 2 else {
            return
        }
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: item.date)
        dateComponents.hour = timeComponents[0]
        dateComponents.minute = timeComponents[1]
        dateComponents.second = 0

        // 触发时间
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    private func removeNotification(for item: ItemModel) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
    }
}
