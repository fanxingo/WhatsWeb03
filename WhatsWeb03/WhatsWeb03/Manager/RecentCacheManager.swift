//
//  RecentCacheManager.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2026/1/5.
//

import Combine

struct RecentItem: Identifiable {
    let id = UUID()
    let productId : String
    let icon: String
    let title: String
}

class RecentCacheManager: ObservableObject {
    static let shared = RecentCacheManager()
    @Published var recentItems: [RecentItem] = []
    
    private init() {
        reloadRecentItems()
    }
    
    func reloadRecentItems() {
        let list = MbDoubleOpenManager.shared().getSavedCacheList()
        recentItems = list.map {
            RecentItem(
                productId: $0,
                icon: "chat_item1",
                title: "WhatsApp"
            )
        }
    }
}
