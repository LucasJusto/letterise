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
    func resetTextField()
}

final class KeyboardViewModel: KeyboardWordKeyboardProtocol, KeyboardWordTextField, ObservableObject {
    @Published var keyboardConfiguration: [Letter]
    @Published var displayedWord: [Letter] = []
    var currentIndex: Int
    weak var letterPackViewModelRef: LetterPackViewModel?
    
    init(letters: [Letter], letterPackViewModelRef: LetterPackViewModel? = nil) {
        self._keyboardConfiguration = Published(initialValue: LettersHandler.lettersWithID(from: letters))
        self._displayedWord = Published(initialValue: LettersHandler.lettersWithID(from: letters))
        self.currentIndex = 0
        self.letterPackViewModelRef = letterPackViewModelRef
        hideAllTyped()
    }
    
    func playSound(sound: SoundOption) {
        let player: SoundPlayer = SoundPlayer()
        player.playSound(sound: sound)
    }
    
    func tryWord() {
        let word: String = getWordFromTextField()
        
        if let letterPackVM = self.letterPackViewModelRef {
            letterPackVM.tryWord(word: word)
        } else {
            print("At KeyboardViewModel tried to access LetterPackViewModelRef without holding a reference")
        }
        
        resetTextField()
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
    
    func resetTextField() {
        for index in 0..<displayedWord.count {
            if !displayedWord[index].isEmpty {
                removeLetter(index: index)
            } else {
                break
            }
        }
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
