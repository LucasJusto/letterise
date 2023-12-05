//
//  GetCoinsView.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 04/12/23.
//

import SwiftUI

struct GetCoinsView: View {
    @Environment(\.designTokens) var tokens
    
//    @StateObject private var rewardManager = RewardAdsManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                
                DSText("Get coins")
                    .textStyle(tokens.font.title, withColor: tokens.color.label.primary)
                    .padding(.vertical, 24)
                
                GetCoinsRow(label: "Get 10 free coins", imageName: "coins1")
                    .onTapGesture {
//                        rewardManager.displayReward()
                    }
                
                GetCoinsRow(label: "Buy 50 coins", imageName: "coins2")
                
                GetCoinsRow(label: "Buy 100 coins", imageName: "coins3")
                
                GetCoinsRow(label: "Buy 150 coins", imageName: "coins4")
                
            }.padding(.horizontal)
        }
//        .onAppear{
//            rewardManager.loadReward(unitIDRewarded: AdMobService.instance.test)
//        }
//        .disabled(!rewardManager.rewardLoaded)

    }
}

#Preview {
    GetCoinsView()
}
