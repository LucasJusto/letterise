//
//  StoreKit.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 23/11/23.
//

import Foundation
import StoreKit

//alias
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo //The Product.SubscriptionInfo.RenewalInfo provides information about the next subscription renewal period.
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState // the renewal states of auto-renewable subscriptions.

class StoreKitViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    
    //TODO: - paste here all products identifiers
    private let productIds: [String] = ["com.letterise.credits1"]
    
    var updateListenerTask : Task<Void, Error>? = nil
    
    //This run when app launch to verify past purchases
    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await requestProducts()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("transaction failed verification")
                }
            }
        }
    }
    
    // Request the products
    @MainActor
    func requestProducts() async {
        do {
            products = try await Product.products(for: productIds)
        } catch {
            print("Failed product request from app store server: \(error)")
        }
    }
    
    // purchase the product
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            //Verify if transaction is valid
            let transaction = try checkVerified(verification)
            
            //The transaction is verified. Deliver content to the user.
            await updateCustomerProductStatus()
            
            await transaction.finish()
            print("Sucessfull purchase")
            return transaction
        case .pending:
            print("Pending payment")
            return nil
        case .userCancelled:
            print("User cancel purchase")
            return nil
        default:
            print("Generic error")
            return nil
        }
    }
    
    //Verify if transaction is valid
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            //The result is verified. Return the unwrapped value.
            return safe
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                //TODO: - here stay the logic to unlock featers to user
                switch transaction.productType {
                case .nonRenewable:
                    if transaction.productID == "" {}
                case .consumable:
                    if transaction.productID == "" {}
                case .nonConsumable:
                    if transaction.productID == "com.letterise.credits1" {
                        #warning("Deliver content to user")
                    }
                case .autoRenewable:
                    if transaction.productID == "" {}
                default:
                    break
                }
                
                await transaction.finish()
            } catch {
                print("failed updating products")
            }
        }
    }
    
}

public enum StoreError: Error {
    case failedVerification
}
