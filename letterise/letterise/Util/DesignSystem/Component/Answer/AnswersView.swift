//
//  AnswersView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct AnswersView: View {
    @Environment(\.designTokens) var tokens
    
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
    
    var body: some View {
        ZStack {
            Image("AnswersBackground")
                .resizable()
                .offset(y: -tokens.padding.xs)
            
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
