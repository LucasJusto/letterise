//
//  KeyboardWordView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct KeyboardWordView: View {
    @Environment(\.designTokens) var tokens

    let type: KeyboardWordViewType
    @ObservedObject var viewModel: KeyboardViewModel
    
    var body: some View {
        HStack(spacing: tokens.padding.xquarck) {
            ForEach(0..<wordArray.count, id: \.self) { index in
                KeyboardLetterView(letter: wordArray[index])
                    .onTapGesture {
                        if !wordArray[index].isEmpty {
                            viewModel.playSound(sound: .tap)
                        }
                        
                        if type == .keyboard {
                            viewModel.type(index: index)
                        }
                        else if type == .textField {
                            viewModel.removeLetter(index: index)
                        }
                    }
            }
        }
    }
    
    private var wordArray: [Letter] {
        type == .keyboard ? viewModel.keyboardConfiguration : viewModel.displayedWord
    }
}

enum KeyboardWordViewType {
    case keyboard, textField
}

#Preview {
    KeyboardWordView(type: .textField, viewModel: KeyboardViewModel(letters: [Letter(char: "D"), Letter(char: "O"), Letter(char: "G")]))
}
