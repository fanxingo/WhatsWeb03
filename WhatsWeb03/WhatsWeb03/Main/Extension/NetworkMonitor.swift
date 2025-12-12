//
//  Untitled.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    private(set) var isConnected: Bool = false
    private var hasAlreadyLoaded: Bool = false

    private init() {}

    func startMonitoring(onFirstConnected: @escaping () -> Void) {
        monitor.pathUpdateHandler = { path in
            let isNowConnected = path.status == .satisfied

            if isNowConnected && !self.isConnected {
                print("✅ 网络首次连接")
                DispatchQueue.main.async {
                    if !self.hasAlreadyLoaded {
                        onFirstConnected()
                        self.hasAlreadyLoaded = true
                    }
                }
            }

            if !isNowConnected {
                print("❌ 无网络")
            }

            self.isConnected = isNowConnected
        }

        monitor.start(queue: queue)
    }

    func resetLoadState() {
        hasAlreadyLoaded = false
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
