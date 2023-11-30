//
//  LetterPackRowView.swift
//  letterise
//
//  Created by Lucas Justo on 28/11/23.
//

import SwiftUI

struct LetterPackRowView: View {
    @Environment(\.designTokens) var tokens
    
    let letterPack: LetterPackDisplay
    
    var body: some View {
        HStack {
            ForEach(0..<letterPack.letters.count, id: \.self) { index in
                KeyboardLetterView(letter: letterPack.letters[index])
            }
        }
        .padding(tokens.padding.xxxs)
        .background {
            Image("KeyboardBackground")
                .resizable()
        }
    }
}

#Preview {
    LetterPackRowView(letterPack: LetterPackDisplay(id: 0, letters: Word(word: "amanco").word, isFree: true, isOwned: true, price: 5))
}
