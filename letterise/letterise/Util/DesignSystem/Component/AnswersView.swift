//
//  AnswersView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct AnswersView: View {
    @Environment(\.designTokens) var tokens
    
    var answers: [String]
    let rows: [GridItem] = [
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 0),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 0),
        GridItem(.flexible(minimum: 0, maximum: 25), spacing: 0)
    ]
    
    var body: some View {
        ZStack {
            Image("AnswersBackground")
                .resizable()
            
            VStack(alignment: .leading) {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, content: {
                        ForEach(answers, id: \.self) { answer in
                            AnswerWordView(word: answer)
                        }
                    })
                }
                
                Spacer()
            }
            .padding(.horizontal, tokens.padding.xxs)
            
        }
    }
}

#Preview {
    AnswersView(answers: ["  ", "ra", "   ", "caro", "arco"])
}
