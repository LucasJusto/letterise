//
//  AnswersView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct AnswersView: View {
    @Environment(\.designTokens) var tokens
    @EnvironmentObject var viewModel: LetterPackViewModel
    
    @Binding var isLoading: Bool
    
    var answers: [Word]
    let rows: [GridItem] = [
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 4),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 4),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 4),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 4),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 4),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 4),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 4),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 4),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 4),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 4)
    ]
    
    init(answers: [Word], isLoading: Binding<Bool>) {
        self.answers = answers
        self._isLoading = isLoading
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack {
            Image("AnswersBackground")
                .resizable()
            
            VStack {
                HStack(spacing: tokens.padding.xquarck) {
                    Image(systemName: "chevron.left")
                        .fontWeight(.bold)
                        .padding(.leading, tokens.padding.xxs)
                        
                    DSText("Back")
                        .textStyle(tokens.font.standard, withColor: tokens.color.label.primary)
                    
                    Spacer()
                    
                    CoinCountView(count: AuthSingleton.shared.actualUser.credits)
                        .padding(.trailing, tokens.padding.xxs)
                }
                .onTapGesture {
                    viewModel.dismiss()
                }
                Spacer()
            }
            .padding(.top, tokens.padding.sm)
            
            if isLoading {
                ProgressView()
                    .scaleEffect(CGSize(width: 2, height: 2))
            } else {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal) {
                        LazyHGrid(
                            rows: rows,
                            alignment: .top,
                            spacing: tokens.padding.micro,
                            content:
                        {
                            ForEach(answers) { answer in
                                AnswerWordView(word: answer)
                                    .padding(1)
                            }
                        })
                    }
                    
                    Spacer()
                }
                    .padding(.horizontal, tokens.padding.xs)
                    .padding(.top, tokens.padding.hundred)
            }
        }
    }
}
