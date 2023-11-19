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
            
            DSButton(label: "Try word") {
                print("Tried")
            }
            .frame(maxHeight: 50)
            .padding(.top, tokens.padding.xxs)
            .padding(.bottom, tokens.padding.xs)
            .padding(.horizontal, tokens.padding.sm)
        }
    }
}

#Preview {
    LetterPackView(
        letterPack: try! LetterPack(
            letters: ["c", "a", "r", "o"],
            answers: ["caro", "ar", "aro", "arco", "ra"]))
}
