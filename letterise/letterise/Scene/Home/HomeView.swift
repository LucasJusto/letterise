//
//  HomeView.swift
//  letterise
//
//  Created by Lucas Justo on 11/12/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.designTokens) var tokens
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @StateObject private var rewardManager = RewardAdsManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                LetteriseTopView(openGetCoins: {
                    viewModel.setIsShowingGetCoinsView(bool: true)
                })
                .navigationDestination(isPresented: $viewModel.isShowingGetCoinsView){
                    GetCoinsView(showAd: {
                        rewardManager.displayReward()
                    })
                }
                
                Image("letterise")
                    .resizable()
                    .frame(height: 60)
                    .padding(.horizontal, tokens.padding.sm)
                    .padding(.top, tokens.padding.bg)
                
                Button(action: {
                    viewModel.setIsShowingPacksListView(bool: true)
                }, label: {
                    OrangeWordView(word: Word(word: "Play"))
                        .padding(.vertical, tokens.padding.xs)
                })
                .navigationDestination(isPresented: $viewModel.isShowingPacksListView){
                    PacksListView()
                }
                
                
                
                Spacer()
            }
            .ignoresSafeArea()
        }
        .accentColor(tokens.color.label.primary)
        .onAppear{
            rewardManager.loadReward()
        }
        .disabled(!rewardManager.rewardLoaded)
    }
}

#Preview {
    HomeView()
}
