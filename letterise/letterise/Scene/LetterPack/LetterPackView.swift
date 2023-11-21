//
//  LetterPackView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct LetterPackView: View {
    @Environment(\.designTokens) var tokens
    
    @ObservedObject var viewModel: LetterPackViewModel
    
    init(letterPack: LetterPack) {
        self._viewModel = ObservedObject(initialValue: LetterPackViewModel(letterPack: letterPack))
    }
    
    var body: some View {
        VStack {
            AnswersView(answers: viewModel.answered)
            
            KeyboardView(letters: viewModel.letterPack.letters, letterPackViewModelRef: viewModel)
        }
    }
}

#Preview {
    LetterPackView(
        letterPack: try! LetterPack(
            letters: [Letter(char: "c"), Letter(char: "a"), Letter(char: "r"), Letter(char: "o")],
            answers: ["caro", "ar", "aro", "arco", "ra"]))
}

