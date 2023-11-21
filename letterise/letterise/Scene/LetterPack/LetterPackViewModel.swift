//
//  LetterPackViewModel.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import Foundation

protocol LetterPackViewModelProtocol {
    var answered: [Word] { get set }
    var lastTriedWordResult: AnswerPossibility { get set }
    func tryWord(word: String)
}

final class LetterPackViewModel: ObservableObject, LetterPackViewModelProtocol {
    var letterPack: LetterPack
    
    @Published var answered: [Word]
    @Published var lastTriedWordResult: AnswerPossibility
    
    init(letterPack: LetterPack) {
        self.letterPack = letterPack
        self.answered = []
        self.lastTriedWordResult = .alreadyFound
        
        initEmptyPlaceholders(letterPack: letterPack)
    }
    
    func tryWord(word: String) {
        if let foundWordIndex =  tryFindingWordIndexAtAnswers(wordToFind: word) {
            let foundWord: Word = answered[foundWordIndex]
            
            if !foundWord.isDiscovered {
                revealWordAtIndex(index: foundWordIndex)
                checkCompletedPack()
                lastTriedWordResult = .correct
            } else {
                lastTriedWordResult = .alreadyFound
            }
        } else {
            lastTriedWordResult = .incorrect
        }
    }
    
    private func checkCompletedPack() {
        #warning("implement")
    }
    
    private func revealWordAtIndex(index: Int) {
        answered[index].isDiscovered = true
        answered[index].word = LettersHandler.reveal(letters: answered[index].word)
    }
    
    private func tryFindingWordIndexAtAnswers(wordToFind: String) -> Int? {
        var wordIndex: Int? = nil
        
        for index in 0..<answered.count {
            if answered[index].asString == wordToFind {
                wordIndex = index
                break
            }
        }
        
        return wordIndex
    }
    
    private func initEmptyPlaceholders(letterPack: LetterPack) {
        self.answered = buildEmptyAnswered(letterPack: letterPack)
    }
    
    private func buildEmptyAnswered(letterPack: LetterPack) -> [Word] {
        var answered: [Word] = []
        var index = 0
        
        for answer in letterPack.answers {
            var word: Word = Word(id: index, word: answer)
            index += 1
            
            word.word = LettersHandler.hide(letters: word.word)
            
            answered.append(word)
        }
        
        return answered
    }
}

enum AnswerPossibility {
    case correct, incorrect, alreadyFound
}
