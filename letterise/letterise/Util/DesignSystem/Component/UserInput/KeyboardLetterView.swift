//
//  KeyboardLetterView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct KeyboardLetterView: View {
    @Environment(\.designTokens) var tokens
    let constants: KeyboardLetterViewConstants = KeyboardLetterViewConstants()
    
    let letter: Letter
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: tokens.borderRadius.sm)
                .stroke(tokens.color.border.primary, lineWidth: tokens.border.sm)
            
            DSText("\(presentedLetter.uppercased())")
                .textStyle(tokens.font.big, withColor: tokens.color.label.primary)
        }
        .frame(minWidth: constants.width, maxWidth: constants.biggerWidth, minHeight: constants.height, maxHeight: constants.biggerHeight)
        .background {
            RoundedRectangle(cornerRadius: tokens.borderRadius.sm)
                .foregroundColor(tokens.color.background.primary)
        }
    }
    
    private var presentedLetter: Character {
        letter.isEmpty ? letter.emptyChar : letter.char
    }
}

#Preview {
    KeyboardLetterView(letter: Letter(char: "A", isEmpty: false))
}

struct KeyboardLetterViewConstants {
    let width: CGFloat = 20
    let height: CGFloat = 20
    
    let biggerWidth: CGFloat = 55
    let biggerHeight: CGFloat = 55
}
