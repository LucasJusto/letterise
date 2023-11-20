//
//  LetterPackView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct LetterPackView: View {
    @Environment(\.designTokens) var tokens
    
    private var viewModel: LetterPackViewModelProtocol
    
    init(letterPack: LetterPack) {
        self.viewModel = LetterPackViewModel(letterPack: letterPack)
    }
    
    var body: some View {
        VStack {
            AnswersView(answers: viewModel.answered)
            
            KeyboardView(letters: viewModel.letterOptions)
        }
    }
}

#Preview {
    LetterPackView(
        letterPack: try! LetterPack(
            letters: [Letter(char: "c"), Letter(char: "a"), Letter(char: "r"), Letter(char: "o")],
            answers: ["caro", "ar", "aro", "arco", "ra"]))
}

