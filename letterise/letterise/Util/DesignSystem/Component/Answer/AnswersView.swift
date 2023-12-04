//
//  AnswersView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct AnswersView: View {
    @Environment(\.designTokens) var tokens
    
    @Binding var isLoading: Bool
    
    var answers: [Word]
    let rows: [GridItem] = [
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 8)
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
                    .padding(.top, tokens.padding.sm)
            }
        }
    }
}

//#Preview {
//    AnswersView(answers: AnswersPreviewGenerator.generateAnswersForPreview())
//}
//
//struct AnswersPreviewGenerator {
//    static func generateAnswersForPreview() -> [String] {
//        var answers: [String] = ["  ", "ra", "   ", "caro", "arco"]
//        
//        for i in 1...50 {
//            answers.append("arco\(i)")
//        }
//        
//        return answers
//    }
//}
