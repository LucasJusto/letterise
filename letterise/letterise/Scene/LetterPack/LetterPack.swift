//
//  LetterPack.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import Foundation

struct LetterPack {
    let id: Int
    let letters: [Letter]
    let answers: [String]
    
    init(id: Int = 0, letters: [Letter], answers: [String]) throws {
        try LetterPackChecker.validate(letters: letters, answers: answers)
        
        self.id = id
        self.letters = letters
        self.answers = answers
    }
}

struct Word: Equatable, Identifiable {
    let id: Int
    var word: [Letter]
    var isDiscovered: Bool = false
    var asString: String {
        LettersHandler.lettersToString(from: word)
    }
    
    init(id: Int = 0, word: String) {
        self.id = id
        self.word = LettersHandler.stringToLetters(from: word)
    }
    
    init(id: Int = 0, word: [Letter]) {
        self.id = id
        self.word = LettersHandler.lettersWithID(from: word)
    }
    
    static func ==(lhs: Word, rhs: Word) -> Bool {
        return lhs.id == rhs.id &&
        lhs.word == rhs.word
    }
}

struct Letter: Equatable, Identifiable {
    let id: Int
    let char: Character
    let emptyChar: Character = " "
    var isEmpty: Bool
    
    init(id: Int = 0, char: Character, isEmpty: Bool = false) {
        self.id = id
        self.char = char
        self.isEmpty = isEmpty
    }
    
    static func ==(lhs: Letter, rhs: Letter) -> Bool {
        return lhs.id == rhs.id &&
        lhs.char == rhs.char &&
        lhs.emptyChar == rhs.emptyChar &&
        lhs.isEmpty == rhs.isEmpty
    }
}

struct LetterPackChecker {
    static func validate(letters: [Letter], answers: [String]) throws {
        for answer in answers {
            try validateAnswer(letters: letters, answer: answer)
        }
    }
    
    private static func validateAnswer(letters: [Letter], answer: String) throws {
        var lettersLeft: [Letter] = letters
        
        try answer.forEach { letter in
            // could use array operations (contains, firstIndex, remove...) but would need to iterate way too much. so let's do it in only one iteration:
            var foundOne: Bool = false
            
            lettersLeft = lettersLeft.filter { char in
                if char.char == letter && !foundOne {
                    foundOne = true
                    return false
                }
                else {
                    return true
                }
            }
            
            if !foundOne {
                let chars = letters.map { $0.char }
                print(">>>>> Failed when trying to accept answer: \"\(answer)\" for letters: \(chars) <<<<<")
                throw LetterPackError.invalidAnswers
            }
        }
    }
}

enum LetterPackError: Error {
    case invalidAnswers
}
