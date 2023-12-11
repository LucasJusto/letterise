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
    private let url: String = "https://gpt-treinador.herokuapp.com"
    
    @Published var answered: [Word] = [] {
        didSet {
            if self.isPackCompleted() {
                self.endPack(letterPackID: letterPack.id)
            }
        }
    }
    @Published var lastTriedWordResult: AnswerPossibility = .alreadyGuessed
    @Published var isPresentingAnswerFeedback: Bool = false
    @Published var isPresentingCongratulations: Bool = false
    @Published var isLoadingAnswers: Bool = true
    @Published var shouldDismiss: Bool = false
    var answerFeedbackTitle: String = ""
    var answerFeedbackMessage: String = ""
    private var lastTriedWord: String = ""
    private let answerFeedbackDisplayTime: CGFloat = 3
    
    private let constants: LetterPackViewConstants = LetterPackViewConstants()
    
    // MARK: - TIPS
    // letters
    private let lettersTipPriceBase: Int = 15
    private let lettersTipPriceMultiplier: Int = 3
    private let letterTipsAskedLimit = 2
    private var letterTipsAsked: Int = 0
    @Published var isProcessingLetterTip: Bool = false
    
    // words
    private let wordsTipPricePerMissingWord: Int = 5
    @Published var isProcessingWordTip: Bool = false
    
    init(letterPack: LetterPack) {
        self.letterPack = letterPack
    }
    
    func loadAnswers() async {
        let result = await fetchAnswers(letterPackID: letterPack.id)
        
        switch result {
        case .success(let answers):
            do {
                self.letterPack = try LetterPack(id: letterPack.id, letters: letterPack.letters, answers: answers)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.isLoadingAnswers = false
                    self.initEmptyPlaceholders(letterPack: letterPack)
                    self.sortAnswers()
                }
            } catch {
                print(error)
                shouldDismiss = true
            }
            
        case .failure(let error):
            print(error)
            shouldDismiss = true
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.shouldDismiss = true
        }
    }
    
    func tryWord(word: String) {
        lastTriedWord = word
        if !word.isEmpty {
            if let foundWordIndex =  tryFindingWordIndexAtAnswers(wordToFind: word) {
                let foundWord: Word = answered[foundWordIndex]
                
                if !foundWord.isDiscovered {
                    revealWordAtIndex(index: foundWordIndex)
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
    
    func getWordsTipPrice() -> Int {
        let missingWords: Int = calculateMissingWords()
        
        return wordsTipPricePerMissingWord * (1 + answered.count - missingWords)
    }
    
    func wordsTipAction() {
        if !isProcessingWordTip {
            setIsProcessingWordTip(bool: true)
            
            let price = getWordsTipPrice()
            
            AuthSingleton.shared.spendCredits(amount: "\(price)") { [weak self] worked in
                guard let self = self else { return }
                
                if worked {
                    displayWordTip()
                }
                self.setIsProcessingWordTip(bool: false)
            }
        }
    }
    
    func getLettersTipPrice() -> Int {
        let multiplier: Int = letterTipsAsked == 0 ? 1 : lettersTipPriceMultiplier * letterTipsAsked
        return lettersTipPriceBase * multiplier
    }
    
    func canAskLetterTip() -> Bool {
        return letterTipsAsked < letterTipsAskedLimit
    }
    
    func lettersTipAction() {
        if canAskLetterTip() && !isProcessingLetterTip {
            setIsProcessingLetterTip(bool: true)
            let price = getLettersTipPrice()
            
            AuthSingleton.shared.spendCredits(amount: "\(price)") { [weak self] worked in
                guard let self = self else { return }
                
                if worked {
                    letterTipsAsked += 1
                    displayLetterTip()
                }
                self.setIsProcessingLetterTip(bool: false)
            }
        }
    }
    
    private func displayWordTip() {
        let missingWords = getMissingWords()
        
        let randomIndex: Int = Int.random(in: 0..<missingWords.count)
        
        let indexAtAnswered = getIndexAtAnswers(for: missingWords[randomIndex])
        
        revealWordAtIndex(index: indexAtAnswered)
    }
    
    private func getIndexAtAnswers(for word: Word) -> Int {
        for index in 0..<answered.count {
            if answered[index].id == word.id {
                return index
            }
        }
        
        return 0
    }
    
    private func getMissingWords() -> [Word] {
        return answered.filter { word in
            !word.isDiscovered
        }
    }
    
    private func calculateMissingWords() -> Int {
        var missingWords: Int = 0
        
        for word in answered {
            if !word.isDiscovered {
                missingWords += 1
            }
        }
        
        return missingWords
    }
    
    private func setIsProcessingWordTip(bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isProcessingWordTip = bool
        }
    }
    
    private func setIsProcessingLetterTip(bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isProcessingLetterTip = bool
        }
    }
    
    private func displayLetterTip() {
        for index in 0..<answered.count {
            let word = answered[index]
            
            if !word.isDiscovered {
                let size: Int = word.word.count
                
                var randomLetterIndex: Int = Int.random(in: 0..<size)
                
                while !word.word[randomLetterIndex].isEmpty {
                    randomLetterIndex = Int.random(in: 0..<size)
                }
                
                let letter = word.word[randomLetterIndex]
                
                var updatedWordLetters: [Letter] = word.word
                
                
                updatedWordLetters[randomLetterIndex] = Letter(id: letter.id, char: letter.char , isEmpty: false)
                var updatedWord: Word = Word(id: word.id, word: updatedWordLetters)
                updatedWord.checkIsDiscovered()
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.answered[index] = updatedWord
                }
            }
        }
    }
    
    private func fetchAnswers(letterPackID: Int) async -> Result<[String], Error> {
        guard let url = URL(string: "\(url)/letterise/getAnswers?letterPackID=\(letterPackID)") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let answers = jsonResponse["answers"] as? [[String: Any]] {
                let extractedAnswers = answers.compactMap { $0["answer"] as? String }
                return .success(extractedAnswers)
            } else {
                return .failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"]))
            }
        } catch {
            return .failure(error)
        }
    }
    
    private func endPack(letterPackID: Int) {
        //save progress
        addToRanking(userID: "\(AuthSingleton.shared.actualUser.id)", letterPackID: "\(letterPackID)") { result in
            switch result {
            case .success(let responseString):
                print("Save ranking: \(responseString)")
            case .failure(let error):
                print("Error saving ranking: \(error.localizedDescription)")
            }
        }
        //Display congratulations message and option to navigate to main menu
        self.isPresentingCongratulations = true
    }

    func addToRanking(userID: String, letterPackID: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(url)/letterise/add_to_ranking") else {
            completionHandler(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "userID": userID,
            "letterPackID": letterPackID
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completionHandler(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                completionHandler(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Erro na resposta do servidor"])))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                completionHandler(.success(responseString))
            } else {
                completionHandler(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Não foi possível decodificar a resposta"])))
            }
        }

        task.resume()
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
    
    private func isPackCompleted() -> Bool {
        for word in answered {
            if !word.isDiscovered {
                return false
            }
        }
        
        return true
    }
    
    private func revealWordAtIndex(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.answered[index].isDiscovered = true
            self.answered[index].word = LettersHandler.reveal(letters: answered[index].word)
        }
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
        
        if let answers = letterPack.answers {
            for answer in answers {
                var word: Word = Word(id: index, word: answer)
                index += 1
                
                word.word = LettersHandler.hide(letters: word.word)
                
                answered.append(word)
            }
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
