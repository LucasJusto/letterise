//
//  ExempleStoreKitView.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 24/11/23.
//

import SwiftUI
import StoreKit

struct ExempleStoreKitView: View {
    @EnvironmentObject var storeVM: StoreKitViewModel
    @Environment(\.dismiss) var dismiss
    @State var isLoadingPurchase = false

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Image("coin")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.bottom, 16)
                
                Text("10 Credits")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                Text("Credits are used to generate images. Each image will be cost 1 credit to be generated")
                    .font(.system(size: 18, weight: .light))
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width*0.8)
                    .padding(.bottom, 8)
                
                ForEach(storeVM.products) { product in
                    
                    Text("Only \(product.displayPrice)")
                        .font(.system(size: 24, weight: .regular))
                        .padding(.horizontal, 16)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    HStack {
                        Text("Read the")
                            .font(.system(size: 12, weight: .regular))
                        Text("Terms of use (EULA)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        Text("and")
                            .font(.system(size: 12, weight: .regular))
                        Text("Privacy Policy")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                if let url = URL(string: "https://docs.google.com/document/d/16cEeM8HDoHj9pF290_pdwhhwTJf238zGiFaNsSmANd8/edit?usp=sharing") {
                                    UIApplication.shared.open(url)
                                }
                            }
                    }
                    .padding(.bottom, 40)
                    .padding(.top, 40)
                    //TODO: - button to do purchase
//                    ButtonComponent(label: "Purchase 10 credits", isRounded: true, action: {
//                        Task {
//                            await buy(product: product)
//                        }
//                    })
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
            if isLoadingPurchase == true {
                ZStack {
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            ProgressView()
                                .tint(.white)
                            Text("Loading")
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        Spacer()
                    }
                }.background(.black.opacity(0.6))
            }
        }
    }
    
    func buy(product: Product) async {
        isLoadingPurchase = true
        do {
            if let transaction = try await storeVM.purchase(product) {
                isLoadingPurchase = false
                self.dismiss()
            } else {
                isLoadingPurchase = false
            }
        } catch {
            isLoadingPurchase = false
        }
        
    }
}

#Preview {
    ExempleStoreKitView().environmentObject(StoreKitViewModel())
}
