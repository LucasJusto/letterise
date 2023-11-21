//
//  LetterPackViewModel.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import Foundation

protocol LetterPackViewModelProtocol {
    var answered: [String] { get set }
    func tryWord(word: String)
}

final class LetterPackViewModel: ObservableObject, LetterPackViewModelProtocol {
    var letterPack: LetterPack
    
    @Published var answered: [String]
    
    init(letterPack: LetterPack) {
        self.letterPack = letterPack
        self.answered = []
        
        initEmptyPlaceholders(letterPack: letterPack)
    }
    
    func tryWord(word: String) {
        
    }
    
    private func initEmptyPlaceholders(letterPack: LetterPack) {
        self.answered = buildEmptyAnswered(letterPack: letterPack)
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
}
