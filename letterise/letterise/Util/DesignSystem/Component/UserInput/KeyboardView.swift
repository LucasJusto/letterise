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
            
            KeyboardWordView(
                type: .keyboard,
                viewModel: viewModel)
            .padding(tokens.padding.xxxs)
            .background {
                LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .bottomLeading, endPoint: .topTrailing)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            DSButton(label: "Try word") {
                viewModel.tryWord()
            }
            .frame(maxHeight: 50)
            .padding(.bottom, tokens.padding.xxs)
            .padding(.horizontal, tokens.padding.sm)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    KeyboardView(letters: [Letter(char: "d"), Letter(char: "o"), Letter(char: "r"), Letter(char: "i"), Letter(char: "m"), Letter(char: "e")])
}
