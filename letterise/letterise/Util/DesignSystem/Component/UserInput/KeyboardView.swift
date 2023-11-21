//
//  KeyboardView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct KeyboardView: View {
    @Environment(\.designTokens) var tokens
    let letters: [Letter]
    
    @StateObject var viewModel: KeyboardViewModel
    
    init(letters: [Letter], letterPackViewModelRef: LetterPackViewModel? = nil) {
        self.letters = letters
        self._viewModel = StateObject(wrappedValue:KeyboardViewModel(letters: letters, letterPackViewModelRef: letterPackViewModelRef))
    }
    
    var body: some View {
        VStack {
            KeyboardWordView(
                type: .textField,
                viewModel: viewModel)
            .padding(.bottom, tokens.padding.xxxs)
            
            KeyboardWordView(
                type: .keyboard,
                viewModel: viewModel)
            .padding(tokens.padding.xxxs)
            .background {
                Image("KeyboardBackground")
                    .resizable()
            }
            
            DSButton(label: "Try word") {
                viewModel.tryWord()
            }
            .frame(maxHeight: 50)
            .padding(.top, tokens.padding.xxs)
            .padding(.bottom, tokens.padding.xs)
            .padding(.horizontal, tokens.padding.sm)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    KeyboardView(letters: [Letter(char: "d"), Letter(char: "o"), Letter(char: "r"), Letter(char: "i"), Letter(char: "m"), Letter(char: "e")])
}
