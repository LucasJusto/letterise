//
//  PacksListView.swift
//  letterise
//
//  Created by Lucas Justo on 26/11/23.
//

import SwiftUI

struct PacksListView: View {
    @Environment(\.designTokens) var tokens
    
    @StateObject private var rewardManager = RewardAdsManager()
    @StateObject var viewModel: PacksListViewModel = PacksListViewModel()
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    ScrollView {
                        VStack(alignment: .center) {
                            LetteriseTopView(openGetCoins: {
                                viewModel.isShowingGetCoinsView = true
                            })
                            
                            DSText("Letter packs:")
                                .textStyle(tokens.font.title, withColor: tokens.color.label.primary)
                                .padding(.top, tokens.padding.nano)
                                .padding(.bottom, tokens.padding.micro)
                                .padding(.horizontal)
                            if viewModel.packsDict.isEmpty {
                                HStack {
                                    Spacer()
                                        ProgressView()
                                            .tint(.black)
                                    Spacer()
                                }
                                .padding(.top, 24)
                            } else {
                                ForEach(viewModel.packsDict.keys.sorted(), id: \.self) { category in
                                    DSDisclosureGroup(category, isExpanded: true) {
                                        ForEach(viewModel.packsDict[category]!) { letterPack in
                                            LetterPackRowView(letterPack: letterPack)
                                                .onTapGesture {
                                                    viewModel.navigateToLetterPackView(letterPackDisplay: letterPack)
                                                }
                                        }
                                    }.padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom, 80)
                    }
                }
                .ignoresSafeArea()
                .navigationDestination(isPresented: $viewModel.isShowingGetCoinsView){
                    GetCoinsView(showAd: {
                        rewardManager.displayReward()
                    })
                }
            }
            .onAppear {
                viewModel.fetchPacks()
            }
            .fullScreenCover(isPresented: $viewModel.isShowingPlayView){
                LetterPackView(letterPack: viewModel.chosenLetterPack!)
            }
            .onAppear{
                rewardManager.loadReward()
            }
            .disabled(!rewardManager.rewardLoaded)
            VStack {
                Spacer()
                BannerAd(unitID: AdMobService.instance.list)
                    .frame(height: 80)
            }
        }
    }
}

#Preview {
    PacksListView()
}
