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
    @StateObject private var rewardManager = RewardAdsManager()
    
    @State var isLoadingPurchase = false
    @State var isShowingAlert = false
    @State var alertTitle = ""
    @State var alertSubtitle = ""
    @State var isShowingNeedToLogin = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    
                    GetCoinsRow(label: "Get 10 free coins", value: "", imageName: "coins1")
                        .onTapGesture {
                            rewardManager.displayReward()
                        }
                    
                    ForEach(storeVM.products) { product in
                        if "\(product.id)" == "com.letterise.coins.50" {
                            GetCoinsRow(label: "Buy 200 coins", value: product.displayPrice, imageName: "coins2")
                                .onTapGesture {
                                    startBuy(product: product)
                                }
                        }
                    }
                    
                    ForEach(storeVM.products) { product in
                        if "\(product.id)" == "com.letterise.coins.100" {
                            GetCoinsRow(label: "Buy 400 coins", value: product.displayPrice, imageName: "coins3")
                                .onTapGesture {
                                    startBuy(product: product)
                                }
                        }
                    }
                    
                    ForEach(storeVM.products) { product in
                        if "\(product.id)" == "com.letterise.coins.300" {
                            GetCoinsRow(label: "Buy 1200 coins", value: product.displayPrice, imageName: "coins4")
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
            .sheet(isPresented: $isShowingNeedToLogin) {
                NeedToLoginView(isShowingNeedToLogin: $isShowingNeedToLogin)
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
        .onAppear{
            rewardManager.loadReward()
        }
        .disabled(!rewardManager.rewardLoaded)
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
    
    func removeLoading(isSuccess: Bool = false) {
        isLoadingPurchase = false
        
        if isSuccess && AuthSingleton.shared.authenticationStatus == .inauthenticated {
            isShowingNeedToLogin = true
        }
    }
    
    func buy(product: Product) async {
        isLoadingPurchase = true
        do {
            if let transaction = try await storeVM.purchase(product) {
                if "\(transaction.productID)" == "com.letterise.coins.50" {
                    AuthSingleton.shared.addCredits(amount: "200") { result in
                        if result {
                            removeLoading(isSuccess: true)
                        } else {
                            removeLoading()
                            showErrorAlert()
                        }
                    }
                    isLoadingPurchase = false
                } else if "\(transaction.productID)" == "com.letterise.coins.100" {
                    AuthSingleton.shared.addCredits(amount: "400") { result in
                        if result {
                            // The StoreKit already show the success alert
                            removeLoading(isSuccess: true)
                        } else {
                            removeLoading()
                            showErrorAlert()
                        }
                    }
                    isLoadingPurchase = false
                } else if "\(transaction.productID)" == "com.letterise.coins.300" {
                    AuthSingleton.shared.addCredits(amount: "1200") { result in
                        if result {
                            removeLoading(isSuccess: true)
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
    GetCoinsView()
}
