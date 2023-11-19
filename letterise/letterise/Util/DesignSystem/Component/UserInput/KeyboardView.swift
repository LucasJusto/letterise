//
//  KeyboardView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct KeyboardView: View {
    @Environment(\.designTokens) var tokens
    @State var options: [Character]
    @State var typed: [Character]
    let letters: [Character]
    
    var viewModel: KeyboardViewModelProtocol
    
    init(letters: [Character]) {
        self.letters = letters
        self.viewModel = KeyboardViewModel()
        self._options = State(initialValue: letters)
        self._typed = State(initialValue: self.viewModel.spaceFilledArray(letters: letters))
    }
    
    var body: some View {
        VStack {
            AnswerWordView(
                word: viewModel.toString(chars: typed),
                size: .big)
            .padding(.bottom, tokens.padding.xxxs)
            
            AnswerWordView(
                word: viewModel.toString(chars: options),
                size: .big)
            .padding(tokens.padding.xxxs)
            .background {
                Image("KeyboardBackground")
                    .resizable()
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    KeyboardView(letters: ["d", "o", "r", "i", "m", "e"])
}
