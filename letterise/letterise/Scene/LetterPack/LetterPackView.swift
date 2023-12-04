//
//  LetterPackView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct LetterPackView: View {
    @Environment(\.designTokens) var tokens
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: LetterPackViewModel
    
    init(letterPack: LetterPack) {
        self._viewModel = StateObject(wrappedValue: LetterPackViewModel(letterPack: letterPack))
    }
    
    var body: some View {
        if viewModel.isPresentingCongratulations {
            CongratulationsView(backToMenuAction: {
                dismiss()
            })
        } else {
            ZStack {
                VStack {
                    AnswersView(answers: viewModel.answered, isLoading: $viewModel.isLoadingAnswers)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.01)
                        .padding(.horizontal)
                    
                    KeyboardView(
                        letters: viewModel.letterPack.letters,
                        letterPackViewModelRef: viewModel)
                    
                    Text("Back to list")
                        .padding(.bottom, UIScreen.main.bounds.height * 0.05)
                        .onTapGesture {
                            dismiss()
                        }
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
            .ignoresSafeArea()
            .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadAnswers()
                }
            }
        }
    }
}

#Preview {
    LetterPackView(
        letterPack: try! LetterPack(
            letters: [Letter(char: "c"), Letter(char: "c"), Letter(char: "a"), Letter(char: "r"), Letter(char: "o")],
            answers: ["caro", "ar", "aro", "arco", "ra"]))
}

