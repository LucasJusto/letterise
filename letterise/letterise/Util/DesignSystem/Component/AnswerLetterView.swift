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
    
    let letter: Character
    let width: CGFloat
    let height: CGFloat
    let fontStyle: FontStyle
    
    init(letter: Character, size: LetterSize = .standard) {
        self.letter = letter
        self.width = size == .standard ? constants.width : constants.biggerWidth
        self.height = size == .standard ? constants.height : constants.biggerHeight
        self.fontStyle = size == .standard ? Fonts().standard : Fonts().big
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: tokens.borderRadius.sm)
                .stroke(tokens.color.border.primary, lineWidth: tokens.border.sm)
            
            DSText("\(letter.uppercased())")
                .textStyle(fontStyle, withColor: tokens.color.label.primary)
        }
        .frame(minWidth: constants.width, maxWidth: width, minHeight: constants.height, maxHeight: height)
        .background {
            RoundedRectangle(cornerRadius: tokens.borderRadius.sm)
                .foregroundColor(tokens.color.background.primary)
        }
    }
}

#Preview {
    AnswerLetterView(letter: "A", size: .big)
}

enum LetterSize {
    case standard, big
}

struct AnswerLetterViewConstants {
    let width: CGFloat = 20
    let height: CGFloat = 20
    
    let biggerWidth: CGFloat = 55
    let biggerHeight: CGFloat = 55
}
