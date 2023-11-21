//
//  AnswerLetterView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct AnswerLetterView: View {
    @Environment(\.designTokens) var tokens
    let constants: AnswerLetterViewConstants = AnswerLetterViewConstants()
    
    let letter: Letter
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: tokens.borderRadius.sm)
                .stroke(tokens.color.border.primary, lineWidth: tokens.border.sm)
            
            DSText("\(presentedLetter.uppercased())")
                .textStyle(tokens.font.standard, withColor: tokens.color.label.primary)
        }
        .frame(width: constants.width, height: constants.height)
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
    AnswerLetterView(letter: Letter(char: "A"))
}

enum LetterSize {
    case standard, big
}

struct AnswerLetterViewConstants {
    let width: CGFloat = 20
    let height: CGFloat = 20
}
