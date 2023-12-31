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

    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .center) {
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
            .navigationDestination(isPresented: $viewModel.isShowingGetCoinsView){
                GetCoinsView()
            }
            VStack {
                Spacer()
                BannerAd(unitID: AdMobService.instance.list)
                    .frame(height: 80)
            }
        }
        .navigationTitle("Letter packs")
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
    }
}

#Preview {
    PacksListView()
}
