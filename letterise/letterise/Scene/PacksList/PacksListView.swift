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
    @State var letterPack: LetterPack?
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center) {
                    LetteriseTopView()
                    
                    DSText("Letter packs:")
                        .textStyle(tokens.font.title, withColor: tokens.color.label.primary)
                        .padding(.top, tokens.padding.nano)
                        .padding(.bottom, tokens.padding.micro)
                        .padding(.horizontal)
                    ForEach(viewModel.packsDict.keys.sorted(), id: \.self) { category in
                        DSDisclosureGroup(category, isExpanded: true) {
                            ForEach(viewModel.packsDict[category]!) { letterPack in
                                LetterPackRowView(letterPack: letterPack)
                                    .onTapGesture {
                                        viewModel.isLoadingAnswers = true
                                        Task {
                                            let letterPackDisplay = letterPack
                                            let result = await viewModel.getLetterPack(from: letterPackDisplay)
                                            
                                            switch result {
                                            case .success(let letterPack):
                                                print("LetterPack obtido com sucesso: \(letterPack)")
                                                self.letterPack = letterPack
                                                viewModel.isLoadingAnswers = false
                                                viewModel.isShowingPlayView = true
                                                #warning("navegar para tela do jogo LETTERPACKVIEW. tem que converter LetterPackDisplay para LetterPack")
                                            case .failure(let error):
                                                print("Erro ao obter LetterPack: \(error)")
                                                viewModel.isLoadingAnswers = true
                                                #warning("show error alert")
                                            }
                                        }
                                    }
                            }
                        }.padding(.horizontal)
                    }
                }
            }
            Spacer()
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.fetchPacks()
        }
        .fullScreenCover(isPresented: $viewModel.isShowingPlayView){
            LetterPackView(letterPack: self.letterPack!)
        }
    }
}

#Preview {
    PacksListView()
}
