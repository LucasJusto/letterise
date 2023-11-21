//
//  StringHandler.swift
//  letterise
//
//  Created by Lucas Justo on 19/11/23.
//

import Foundation

struct LettersHandler {
    static func stringToLetters(from string: String) -> [Letter] {
        var letters: [Letter] = []

        for index in 0..<string.count {
            letters.append(Letter(id: index, char: Array(string)[index]))
        }

        return letters
    }

    static func lettersToString(from letters: [Letter]) -> String {
        var string: String = ""

        for letter in letters {
            string += "\(letter.char)"
        }

        return string
    }
    
    static func lettersWithID(from letters: [Letter]) -> [Letter] {
        var lettersWithID: [Letter] = []
        
        for index in 0..<letters.count {
            let letter = letters[index]
            lettersWithID.append(Letter(id: index, char: letter.char, isEmpty: letter.isEmpty))
        }
        
        return lettersWithID
    }
    
    static func hide(letters: [Letter]) -> [Letter] {
        let hiddenLetters: [Letter] = letters.map { letter in
            Letter(id: letter.id, char: letter.char, isEmpty: true)
        }
        
        return hiddenLetters
    }
}
