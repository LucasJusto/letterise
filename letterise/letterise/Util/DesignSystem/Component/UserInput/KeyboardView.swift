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
    
    @ObservedObject var viewModel: KeyboardViewModel
    
    init(letters: [Letter]) {
        self.letters = letters
        self.viewModel = KeyboardViewModel(letters: letters)
    }
    
    var body: some View {
        VStack {
            KeyboardWordView(
                word: Word(word: viewModel.typed))
            .padding(.bottom, tokens.padding.xxxs)
            
            KeyboardWordView(
                word: Word(word: viewModel.options))
            .padding(tokens.padding.xxxs)
            .background {
                Image("KeyboardBackground")
                    .resizable()
            }
            
            DSButton(label: "Try word") {
                print("Tried")
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
