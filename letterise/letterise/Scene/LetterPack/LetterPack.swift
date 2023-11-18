//
//  LetterPack.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import Foundation

struct LetterPack {
    let letters: [Character]
    let answers: [String]
    
    init(letters: [Character], answers: [String]) throws {
        try LetterPackChecker.validate(letters: letters, answers: answers)
        
        self.letters = letters
        self.answers = answers
    }
}

struct LetterPackChecker {
    static func validate(letters: [Character], answers: [String]) throws {
        for answer in answers {
            try validateAnswer(letters: letters, answer: answer)
        }
    }
    
    private static func validateAnswer(letters: [Character], answer: String) throws {
        var lettersLeft: [Character] = letters
        
        try answer.forEach { letter in
            // could use array operations (contains, firstIndex, remove...) but would need to iterate way too much. so let's do it in only one iteration:
            var foundOne: Bool = false
            
            lettersLeft = lettersLeft.filter { char in
                if char == letter && !foundOne {
                    foundOne = true
                    return false
                }
                else {
                    return true
                }
            }
            
            if !foundOne {
                print(">>>>> Failed when trying to accept answer: \"\(answer)\" for letters: \(letters) <<<<<")
                throw LetterPackError.invalidAnswers
            }
        }
    }
}

enum LetterPackError: Error {
    case invalidAnswers
}
