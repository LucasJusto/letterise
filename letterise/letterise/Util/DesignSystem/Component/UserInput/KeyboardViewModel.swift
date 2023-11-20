//
//  KeyboardViewModel.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import Foundation

protocol KeyboardViewModelProtocol: ObservableObject {
    func toWord(letters: [Letter]) -> Word
    func hideAllTyped()
}

final class KeyboardViewModel: KeyboardViewModelProtocol {
    @Published var options: [Letter]
    @Published var typed: [Letter] = []
    
    init(letters: [Letter]) {
        self._options = Published(initialValue: letters)
        self._typed = Published(initialValue: letters)
        hideAllTyped()
    }
    
    func toWord(letters: [Letter]) -> Word {
        var string: String = ""
        
        for letter in letters {
            string += "\(letter.char)"
        }
        
        return Word(word: string)
    }
    
    func hideAllTyped() {
        typed = StringHandler.hide(letters: typed)
    }
}
