//
//  RankingView.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 11/12/23.
//

import SwiftUI

struct RankingView: View {
    @Environment(\.designTokens) var tokens
    @StateObject var rankinViewModel: RankingViewModel = RankingViewModel()
    
    var body: some View {
        ScrollView {
            if rankinViewModel.rankings.isEmpty {
                ProgressView()
                    .padding(.top, 32)
            } else {
                HStack {
                    Text("Nickname")
                        .font(.system(size: 12, weight: .light))
                        .padding(.leading, 16)
                    Spacer()
                    Text("Finished packs")
                        .font(.system(size: 10, weight: .light))
                        .padding(.trailing, 16)
                }
                .padding(.vertical, 2)
                .padding(.horizontal, 16)
                ForEach(Array(zip(rankinViewModel.rankings.indices, rankinViewModel.rankings)), id: \.1.id) { index, ranking in
                    HStack {
                        Text("#\(index + 1)  \(ranking.inGameNickname)")
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                        Text("\(ranking.rankingCount)")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .padding()
                    .background(ranking.inGameNickname == AuthSingleton.shared.actualUser.inGameNickName ? Color.orange : Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Ranking")
        .onAppear {
            rankinViewModel.fetchRankingList { result in
                switch result {
                case .success(let rankings):
                    print("success")
                case .failure(let error):
                    print("Erro ao buscar rankings: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    RankingView()
}
