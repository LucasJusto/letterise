//
//  PacksListView.swift
//  letterise
//
//  Created by Lucas Justo on 26/11/23.
//

import SwiftUI

struct PacksListView: View {
    @Environment(\.designTokens) var tokens
    
    @StateObject var viewModel: PacksListViewModel = PacksListViewModel()
    
    var body: some View {
        VStack {
            LetteriseTopView()
            
            DSText("Letter packs:")
                .textStyle(tokens.font.title, withColor: tokens.color.label.primary)
                .padding(.top, tokens.padding.xs)
                .padding(.bottom, tokens.padding.micro)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.packsDict.keys.sorted(), id: \.self) { category in
                        DSDisclosureGroup(category, isExpanded: true) {
                            ForEach(viewModel.packsDict[category]!) { letterPack in
                                LetterPackRowView(letterPack: letterPack)
                                    .onTapGesture {
                                        #warning("navegar para tela do jogo LETTERPACKVIEW. tem que converter LetterPackDisplay para LetterPack")
                                    }
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.fetchPacks()
        }
    }
}

#Preview {
    PacksListView()
}
