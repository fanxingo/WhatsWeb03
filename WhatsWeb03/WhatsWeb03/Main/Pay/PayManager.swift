//
//  PayManager.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2026/1/16.
//

import Foundation
import StoreKit
import Combine


@MainActor
final class PayManager: ObservableObject {
    
    static let shared = PayManager()
    
    @Published var purchaseSuccess: (productId: String, date: Date)? = nil
    @Published var purchaseError: String? = nil

    private var transactionListenerTask: Task<Void, Never>? = nil

    private init() {
        startTransactionListener()
    }
    
    func startTransactionListener() {
        // 保持 Task 引用，防止被释放
        transactionListenerTask = Task {
            for await verificationResult in Transaction.updates {
                await handle(transactionVerification: verificationResult)
            }
        }
    }
    
    @MainActor
    private func handle(transactionVerification: VerificationResult<Transaction>) async {
        switch transactionVerification {
        case .verified(let transaction):
            await transaction.finish()
            // 必须切回主线程设置 @Published
            await MainActor.run {
                self.purchaseSuccess = (transaction.productID, transaction.purchaseDate)
            }
        case .unverified(_, let error):
            await MainActor.run {
                self.purchaseError = "Transaction verification failed：%@".localized(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Purchase Entry
    func purchase(productId: String) async {
        do {
            guard let product = try await Product.products(for: [productId]).first else {
                await MainActor.run {
                    self.purchaseError = "The product information cannot be obtained".localized()
                }
                return
            }
            let purchaseOption = Product.PurchaseOption.appAccountToken(UUID(uuidString: UUIDTool.getUUIDInKeychain())!)
            let result = try await product.purchase(options: [purchaseOption])
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    await MainActor.run {
                        self.purchaseSuccess = (productId: transaction.productID, date: transaction.purchaseDate)
                    }
                case .unverified(_, let error):
                    await MainActor.run {
                        self.purchaseError = "Transaction verification failed：%@".localized(error.localizedDescription)
                    }
                }
            case .userCancelled:
                await MainActor.run {
                    self.purchaseError = "Cancel the purchase".localized()
                }
            case .pending:
                await MainActor.run {
                    self.purchaseError = "pending".localized()
                }
            @unknown default:
                await MainActor.run {
                    self.purchaseError = "Unknown result".localized()
                }
            }
        } catch {
            await MainActor.run {
                self.purchaseError = error.localizedDescription
            }
        }
    }
    
    // MARK: - Restore
    func restore() async {
        do {
            // 1. 先同步 App Store 购买记录（StoreKit2 的推荐做法）
            try await AppStore.sync()
        } catch {
            // 2. 同步失败也要抛出错误
            await MainActor.run {
                self.purchaseError = "failure：%@".localized(error.localizedDescription)
            }
            return
        }
        // 3. 检查当前授权的有效交易
        var latestTransaction: (productId: String, date: Date)? = nil
        var errors: [String] = []

        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if latestTransaction == nil || transaction.purchaseDate > latestTransaction!.date {
                    latestTransaction = (productId: transaction.productID, date: transaction.purchaseDate)
                }
            case .unverified(_, let error):
                errors.append(error.localizedDescription)
            }
        }

        // 4. 统一在主线程触发成功或失败状态
        await MainActor.run {
            if let latest = latestTransaction {
                self.purchaseSuccess = latest
            } else if !errors.isEmpty {
                self.purchaseError = errors.joined(separator: "\n")
            } else {
                self.purchaseError = "There are no recoverable subscriptions".localized()
            }
        }
    }

    deinit {
        transactionListenerTask?.cancel()
    }
}

@MainActor
class SubscriptionProductStore: ObservableObject {
    static let shared = SubscriptionProductStore()

    @Published var products: [Product] = []
    private(set) var productMap: [String: Product] = [:]  // 用于快速按 ID 查找

    private init() {}

    func preloadProducts(ids: [String]) async {
        do {
            let fetched = try await Product.products(for: ids)
            self.products = fetched
            self.productMap = Dictionary(uniqueKeysWithValues: fetched.map { ($0.id, $0) })
            print("✅ 商品信息预加载完成，共 \(fetched.count) 个")
        } catch {
            print("❌ 商品信息预加载失败: \(error.localizedDescription)")
        }
    }
    func product(for id: String) -> Product? {
        return productMap[id]
    }
}


func hasIntroTrial(productID: String) async -> Bool {
    do {
        let storeProducts = try await Product.products(for: [productID])
        guard let product = storeProducts.first,
              let subscription = product.subscription else { return false }
        
        let eligible = await subscription.isEligibleForIntroOffer
        return eligible
    } catch {
        print("获取产品失败: \(error)")
        return false
    }
}
