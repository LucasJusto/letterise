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
    var isPresentingAnswerFeedback: Bool { get set }
    var answerFeedbackTitle: String { get set }
    var answerFeedbackMessage: String { get set }
    func tryWord(word: String)
}

final class LetterPackViewModel: ObservableObject, LetterPackViewModelProtocol {
    var letterPack: LetterPack
    
    @Published var answered: [Word]
    @Published var lastTriedWordResult: AnswerPossibility
    @Published var isPresentingAnswerFeedback: Bool
    var answerFeedbackTitle: String = ""
    var answerFeedbackMessage: String = ""
    private var lastTriedWord: String = ""
    private let answerFeedbackDisplayTime: CGFloat = 3
    
    private let constants: LetterPackViewConstants = LetterPackViewConstants()
    
    init(letterPack: LetterPack) {
        self.letterPack = letterPack
        self.answered = []
        self.lastTriedWordResult = .alreadyGuessed
        self.isPresentingAnswerFeedback = false
        
        initEmptyPlaceholders(letterPack: letterPack)
        sortAnswers()
    }
    
    func tryWord(word: String) {
        lastTriedWord = word
        if !word.isEmpty {
            if let foundWordIndex =  tryFindingWordIndexAtAnswers(wordToFind: word) {
                let foundWord: Word = answered[foundWordIndex]
                
                if !foundWord.isDiscovered {
                    revealWordAtIndex(index: foundWordIndex)
                    checkCompletedPack()
                    setLastTriedWordResult(result: .correct)
                } else {
                    setLastTriedWordResult(result: .alreadyGuessed)
                }
            } else {
                setLastTriedWordResult(result: .incorrect)
            }
            displayAnswerFeedback(word: word)
        }
    }
    
    private func setLastTriedWordResult(result: AnswerPossibility) {
        lastTriedWordResult = result
        
        switch result {
        case .correct:
            answerFeedbackTitle = constants.correctAnswerTitle
            answerFeedbackMessage = constants.correctAnswerMessage
            playSound(sound: .correctAnswer)
            
        case .incorrect:
            answerFeedbackTitle = constants.incorretAnswerTitle
            answerFeedbackMessage = constants.incorrectAnswerMessage
            playSound(sound: .incorrectAnswer)
            
        case .alreadyGuessed:
            answerFeedbackTitle = constants.alreadyGuessedAnswerTitle
            answerFeedbackMessage = constants.alreadyGuessedAnswerMessage
            playSound(sound: .incorrectAnswer)
        }
    }
    
    private func playSound(sound: SoundOption) {
        let player: SoundPlayer = SoundPlayer()
        player.playSound(sound: sound)
    }
    
    private func sortAnswers() {
        answered.sort { word1, word2 in
            return word1.word.count < word2.word.count
        }
    }
    
    private func displayAnswerFeedback(word: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isPresentingAnswerFeedback = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + answerFeedbackDisplayTime) { [weak self] in
                guard let self = self else { return }
                
                if self.isPresentingAnswerFeedback && self.lastTriedWord == word {
                    self.isPresentingAnswerFeedback = false
                }
            }
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
    case correct, incorrect, alreadyGuessed
}

struct LetterPackViewConstants {
    let correctAnswerTitle: String = "Correct"
    let correctAnswerMessage: String = "You guessed a word"
    let incorretAnswerTitle: String = "Incorrect"
    let incorrectAnswerMessage: String = "This word is not expected in the answers' list"
    let alreadyGuessedAnswerTitle: String = "Already Guessed"
    let alreadyGuessedAnswerMessage: String = "You already guessed this word"
}
