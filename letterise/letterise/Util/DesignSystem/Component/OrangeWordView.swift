//
//  OrangeWordView.swift
//  letterise
//
//  Created by Lucas Justo on 11/12/23.
//

import SwiftUI

struct OrangeWordView: View {
    @Environment(\.designTokens) var tokens
    
    let word: Word
    
    var body: some View {
        HStack(spacing: tokens.padding.xquarck) {
            ForEach(0..<word.word.count, id: \.self) { index in
                KeyboardLetterView(letter: word.word[index])
            }
        }
        .padding(tokens.padding.xxxs)
        .background {
            LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .bottomLeading, endPoint: .topTrailing)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    OrangeWordView(word: Word(word: "Play"))
}
