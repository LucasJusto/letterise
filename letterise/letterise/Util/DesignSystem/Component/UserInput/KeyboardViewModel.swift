//
//  KeyboardViewModel.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import Foundation

protocol KeyboardWordKeyboardProtocol {
    var keyboardConfiguration: [Letter] { get set }
    func type(index: Int)
    func untype(letterID: Int)
}

protocol KeyboardWordTextField {
    var displayedWord: [Letter] { get set }
    var currentIndex: Int { get set }
    func insertLetter(letter: Letter)
    func removeLetter(index: Int)
}

final class KeyboardViewModel: KeyboardWordKeyboardProtocol, KeyboardWordTextField, ObservableObject {
    @Published var keyboardConfiguration: [Letter]
    @Published var displayedWord: [Letter] = []
    var currentIndex: Int
    
    init(letters: [Letter]) {
        self._keyboardConfiguration = Published(initialValue: LettersHandler.lettersWithID(from: letters))
        self._displayedWord = Published(initialValue: LettersHandler.lettersWithID(from: letters))
        self.currentIndex = 0
        hideAllTyped()
    }
    
    func tryWord() {
        print("tried: \(getWordFromTextField())")
    }
    
    private func getWordFromTextField() -> String {
        var word: String = ""
        
        for letter in displayedWord {
            if !letter.isEmpty {
                word += "\(letter.char)"
            } else {
                break
            }
        }
        
        return word
    }
    
    func toWord(letters: [Letter]) -> Word {
        var string: String = ""
        
        for letter in letters {
            string += "\(letter.char)"
        }
        
        return Word(word: string)
    }
    
    func hideAllTyped() {
        displayedWord = LettersHandler.hide(letters: displayedWord)
    }
    
    // MARK: - Keyboard
    
    func type(index: Int) {
        if !keyboardConfiguration[index].isEmpty {
            keyboardConfiguration[index].isEmpty = true
            insertLetter(letter: keyboardConfiguration[index])
        }
    }
    
    func untype(letterID: Int) {
        let index = getIndexForKeyboard(id: letterID)
        keyboardConfiguration[index].isEmpty = false
    }
    
    private func getIndexForKeyboard(id: Int) -> Int {
        for index in 0..<keyboardConfiguration.count {
            if keyboardConfiguration[index].id == id {
                return index
            }
        }
        
        return 0
    }
    
    // MARK: - TextField
    
    func insertLetter(letter: Letter) {
        displayedWord[currentIndex] = Letter(id: letter.id, char: letter.char, isEmpty: false)
        currentIndex = calculateNextIndex()
    }
    
    func removeLetter(index: Int) {
        displayedWord[index].isEmpty = true
        untype(letterID: displayedWord[index].id)
        currentIndex = calculateNextIndex()
    }
    
    private func calculateNextIndex() -> Int {
        for index in 0..<displayedWord.count {
            if displayedWord[index].isEmpty {
                return index
            }
        }
        
        return 0
    }
}

enum AnswerPossibility {
    case correct, incorrect, alreadyFound
}
