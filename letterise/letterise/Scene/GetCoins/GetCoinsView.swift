//
//  GetCoinsView.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 04/12/23.
//

import SwiftUI
import StoreKit

struct GetCoinsView: View {
    @Environment(\.designTokens) var tokens
    @StateObject var storeVM: StoreKitViewModel = StoreKitViewModel()
    
    @State var isLoadingPurchase = false
    @State var isShowingAlert = false
    @State var alertTitle = ""
    @State var alertSubtitle = ""
    
    let showAd: () -> Void
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    
                    GetCoinsRow(label: "Get 10 free coins", value: "", imageName: "coins1")
                        .onTapGesture {
                            showAd()
                        }
                    
                    ForEach(storeVM.products) { product in
                        if "\(product.id)" == "com.letterise.coins.50" {
                            GetCoinsRow(label: "Buy 50 coins", value: product.displayPrice, imageName: "coins2")
                                .onTapGesture {
                                    startBuy(product: product)
                                }
                        }
                    }
                    
                    ForEach(storeVM.products) { product in
                        if "\(product.id)" == "com.letterise.coins.100" {
                            GetCoinsRow(label: "Buy 100 coins", value: product.displayPrice, imageName: "coins3")
                                .onTapGesture {
                                    startBuy(product: product)
                                }
                        }
                    }
                    
                    ForEach(storeVM.products) { product in
                        if "\(product.id)" == "com.letterise.coins.300" {
                            GetCoinsRow(label: "Buy 300 coins", value: product.displayPrice, imageName: "coins4")
                                .onTapGesture {
                                    startBuy(product: product)
                                }
                        }
                    }
                    
                    HStack(spacing: 24) {
                        Text("Terms of use (EULA)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        
                        Text("Privacy Policy")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                if let url = URL(string: "https://docs.google.com/document/d/16cEeM8HDoHj9pF290_pdwhhwTJf238zGiFaNsSmANd8/edit?usp=sharing") {
                                    UIApplication.shared.open(url)
                                }
                            }
                    }
                    .padding(.bottom, 32)
                    .padding(.top, 56)
                    
                }
                .navigationTitle("Get coins")
                .padding(.horizontal)
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertSubtitle),
                    dismissButton: .default(Text("OK"))
                )
            }
            if isLoadingPurchase == true {
                ZStack {
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            ProgressView()
                                .tint(.white)
                            Text("Doing purchase,\ndon't close the app")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        Spacer()
                    }
                }.background(.black.opacity(0.6))
            }
        }
    }
    
    func startBuy(product: Product) {
        Task {
            await buy(product: product)
        }
    }
    
    func showErrorAlert() {
        isShowingAlert = true
        alertTitle = "Error"
        alertSubtitle = "Talk with support to resolve if you don't receive your credits"
    }
    
    func removeLoading() {
        isLoadingPurchase = false
    }
    
    func buy(product: Product) async {
        isLoadingPurchase = true
        do {
            if let transaction = try await storeVM.purchase(product) {
                if "\(transaction.productID)" == "com.letterise.coins.50" {
                    AuthSingleton.shared.addCredits(amount: "50") { result in
                        if result {
                            // The StoreKit already show the success alert
                            removeLoading()
                        } else {
                            removeLoading()
                            showErrorAlert()
                        }
                    }
                    isLoadingPurchase = false
                } else if "\(transaction.productID)" == "com.letterise.coins.100" {
                    AuthSingleton.shared.addCredits(amount: "100") { result in
                        if result {
                            // The StoreKit already show the success alert
                            removeLoading()
                        } else {
                            removeLoading()
                            showErrorAlert()
                        }
                    }
                    isLoadingPurchase = false
                } else if "\(transaction.productID)" == "com.letterise.coins.300" {
                    AuthSingleton.shared.addCredits(amount: "300") { result in
                        if result {
                            removeLoading()
                        } else {
                            removeLoading()
                            showErrorAlert()
                        }
                    }
                } else {
                    removeLoading()
                    showErrorAlert()
                }
            } else {
                removeLoading()
                showErrorAlert()
            }
        } catch {
            removeLoading()
            showErrorAlert()
        }
    }
}

#Preview {
    GetCoinsView(showAd: {})
}
