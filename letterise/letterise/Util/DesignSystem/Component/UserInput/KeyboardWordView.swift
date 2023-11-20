//
//  KeyboardWordView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct KeyboardWordView: View {
    @Environment(\.designTokens) var tokens
    
    let word: Word
    
    var body: some View {
        HStack(spacing: tokens.padding.xquarck) {
            ForEach(word.word) { letter in
                KeyboardLetterView(letter: letter)
            }
        }
    }
}

#Preview {
    KeyboardWordView(word: Word(word: "DOG"))
}
