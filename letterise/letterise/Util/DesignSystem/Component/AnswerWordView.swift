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
    
    var body: some View {
        HStack(spacing: tokens.padding.xquarck) {
            ForEach(0..<word.count, id: \.self) { index in
                AnswerLetterView(letter: Array(word)[index])
            }
        }
    }
}

#Preview {
    AnswerWordView(word: "Dog")
}

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
}
