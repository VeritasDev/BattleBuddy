//
//  InAppPurchaseController.swift
//  BattleBuddy
//
//  Created by Mike on 8/16/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchaseController: NSObject {
    private let productIdentifiers: Set<String> = ["support_1"]
    private var productsRequest: SKProductsRequest?

    public func requestProducts() {
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
}


// MARK: - SKProductsRequestDelegate

extension InAppPurchaseController: SKProductsRequestDelegate {

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        clearRequestAndHandler()

        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        clearRequestAndHandler()
    }

    private func clearRequestAndHandler() {
        productsRequest = nil
    }
}
