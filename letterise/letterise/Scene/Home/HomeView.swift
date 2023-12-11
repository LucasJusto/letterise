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
    
    var body: some View {
        NavigationStack {
            VStack {
                LetteriseTopView(openGetCoins: {
                    viewModel.setIsShowingGetCoinsView(bool: true)
                })
                .navigationDestination(isPresented: $viewModel.isShowingGetCoinsView){
                    GetCoinsView()
                }
                
                Image("letterise")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 60)
                    .padding(.horizontal, tokens.padding.sm)
                    .padding(.top, tokens.padding.twoHundred)
                
                Button(action: {
                    viewModel.setIsShowingPacksListView(bool: true)
                }, label: {
                    OrangeWordView(word: Word(word: "Play"))
                        .padding(.vertical, tokens.padding.xs)
                })
                .navigationDestination(isPresented: $viewModel.isShowingPacksListView){
                    PacksListView()
                }
                
                DSButton(label: "Ranking") {
                    viewModel.setIsShowingRankingView(bool: true)
                }
                .frame(height: 40)
                .padding(.horizontal, tokens.padding.hundred)
                .navigationDestination(isPresented: $viewModel.isShowingRankingView){
                    RankingView()
                }
                #warning("add navigation to ranking")
                
                DSText("Settings")
                    .textStyle(tokens.font.standard, withColor: tokens.color.label.primary)
                    .padding(.top, tokens.padding.sm)
                    .onTapGesture {
                        viewModel.setIsShowingSettingsView(bool: true)
                    }
                    .navigationDestination(isPresented: $viewModel.isShowingSettingsView) {
                        SettingsView()
                    }
                
                Spacer()
            }
            .ignoresSafeArea()
        }
        .accentColor(tokens.color.label.primary)
    }
}

#Preview {
    HomeView()
}
