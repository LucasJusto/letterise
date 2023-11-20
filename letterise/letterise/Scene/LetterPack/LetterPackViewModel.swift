//
//  LetterPackViewModel.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import Foundation

protocol LetterPackViewModelProtocol {
    var answered: [String] { get set }
    var letterOptions: [Letter] { get set }
    var typedLetters: [Letter] { get set }
}

final class LetterPackViewModel: ObservableObject, LetterPackViewModelProtocol {
    private var letterPack: LetterPack
    
    @Published var answered: [String]
    @Published var letterOptions: [Letter]
    @Published var typedLetters: [Letter]
    
    init(letterPack: LetterPack) {
        self.letterPack = letterPack
        self.answered = []
        self.letterOptions = letterPack.letters
        self.typedLetters = []
        
        initEmptyPlaceholders(letterPack: letterPack)
    }
    
    private func initEmptyPlaceholders(letterPack: LetterPack) {
        self.answered = buildEmptyAnswered(letterPack: letterPack)
        self.typedLetters = buildEmptyTypedLetters(letterPack: letterPack)
    }
    
    private func buildEmptyAnswered(letterPack: LetterPack) -> [String] {
        var answered: [String] = []
        
        for answer in letterPack.answers {
            var buildedAnswer: String = ""
            
            for _ in answer {
                buildedAnswer += " "
            }
            
            answered.append(buildedAnswer)
        }
        
        return answered
    }
    
    private func buildEmptyTypedLetters(letterPack: LetterPack) -> [Letter] {
        var typedLetters: [Letter] = []
        
        for char in letterPack.letters {
            typedLetters.append(Letter(char: char.char, isEmpty: true))
        }
        
        return typedLetters
    }
}
