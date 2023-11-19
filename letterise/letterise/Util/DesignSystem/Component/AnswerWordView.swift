//
//  AnswerLetterView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct AnswerWordView: View {
    @Environment(\.designTokens) var tokens
    
    let word: String
    let size: LetterSize
    
    init(word: String, size: LetterSize = .standard) {
        self.word = word
        self.size = size
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<word.count, id: \.self) { index in
                AnswerLetterView(letter: Array(word)[index], size: size)
            }
        }
    }
    
    private var spacing: CGFloat {
        return size == .standard ? tokens.padding.xquarck : tokens.padding.nano
    }
}

#Preview {
    AnswerWordView(word: "Dog", size: .big)
}

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
}
