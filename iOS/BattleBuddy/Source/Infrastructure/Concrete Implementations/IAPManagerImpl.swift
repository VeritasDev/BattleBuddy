//
//  IAPManagerImpl.swift
//  BattleBuddy
//
//  Created by Veritas on 8/3/20.
//  Copyright © 2020 Veritas. All rights reserved.
//

import Foundation
import StoreKit

enum InAppPurchase: String, CaseIterable {
    case tier1 = "tier_1"
    case tier2 = "tier_2"
    case tier3 = "tier_3"
}

class IAPManagerImpl: NSObject, IAPManager {
    private var products: [SKProduct] = []
    var onReceiveProductsHandler: (([SKProduct]) -> Void)?

    func getProducts() -> [SKProduct] {
        return products
    }

    func preloadProducts(withHandler productsReceiveHandler: @escaping (_ result: [SKProduct]) -> Void) {
        onReceiveProductsHandler = productsReceiveHandler

        let productIds = Set(InAppPurchase.allCases.map{ $0.rawValue })
        let request = SKProductsRequest(productIdentifiers: productIds)
        request.delegate = self
        request.start()
    }

    func purchaseProduct(_ product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else { print("Purchases are disabled in your device!") }
    }
}

extension IAPManagerImpl: SKProductsRequestDelegate {
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {

    }
}

extension IAPManagerImpl: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
            for transaction:AnyObject in transactions {
                if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                    switch trans.transactionState {

                    case .purchased:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        break

                    case .failed:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        print("Payment has failed.")
                        break
                    case .restored:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        print("Purchase has been successfully restored!")
                        break

                    default: break
            }}}
    }

    func restorePurchase() {
            SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
            SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
            print("The Payment was successfull!")
    }

    func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }

    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
}
