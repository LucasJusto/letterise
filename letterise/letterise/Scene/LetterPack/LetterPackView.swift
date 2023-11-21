//
//  LetterPackView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct LetterPackView: View {
    @Environment(\.designTokens) var tokens
    
    @StateObject var viewModel: LetterPackViewModel
    
    init(letterPack: LetterPack) {
        self._viewModel = StateObject(wrappedValue: LetterPackViewModel(letterPack: letterPack))
    }
    
    var body: some View {
        ZStack {
            VStack {
                AnswersView(answers: viewModel.answered)
                
                KeyboardView(
                    letters: viewModel.letterPack.letters,
                    letterPackViewModelRef: viewModel)
            }
            
            if viewModel.isPresentingAnswerFeedback {
                AnswerFeedbackView(
                    title: viewModel.answerFeedbackTitle,
                    message: viewModel.answerFeedbackMessage)
                .onTapGesture {
                    DispatchQueue.main.async {
                        self.viewModel.isPresentingAnswerFeedback = false
                    }
                }
            }
        }
    }
}

#Preview {
    LetterPackView(
        letterPack: try! LetterPack(
            letters: [Letter(char: "c"), Letter(char: "a"), Letter(char: "r"), Letter(char: "o")],
            answers: ["caro", "ar", "aro", "arco", "ra"]))
}

