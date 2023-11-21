//
//  AnswerLetterView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct AnswerWordView: View {
    @Environment(\.designTokens) var tokens
    
    let word: Word
    
    var body: some View {
        HStack(spacing: tokens.padding.xquarck) {
            ForEach(0..<word.word.count, id: \.self) { index in
                AnswerLetterView(letter: word.word[index])
            }
        }
    }
}

#Preview {
    AnswerWordView(word: Word(word: "DOG"))
}
