//
//  PacksListViewModel.swift
//  letterise
//
//  Created by Lucas Justo on 28/11/23.
//

import Foundation

final class PacksListViewModel: ObservableObject {
    @Published var packsDict: [String: [LetterPackDisplay]] = [:]
    
    func fetchPacks() {
        #warning("fetch letter packs")
        
        packsDict = [
            "packs with 3 letters": [LetterPackDisplay(id: 0, letters: Word(word: "aro").word, isFree: true, isOwned: true, price: 0),
                  LetterPackDisplay(id: 1, letters: Word(word: "paz").word, isFree: true, isOwned: true, price: 0)],
            "packs with 4 letters": [LetterPackDisplay(id: 2, letters: Word(word: "caro").word, isFree: true, isOwned: true, price: 0),
                  LetterPackDisplay(id: 3, letters: Word(word: "loca").word, isFree: true, isOwned: true, price: 0)]
        ]
    }
    
    func getLetterPack(from letterPackDisplay: LetterPackDisplay) async -> LetterPack {
        let answers = await fetchAnswers(letterPackID: letterPackDisplay.id)
        
        return try! LetterPack(
            id: letterPackDisplay.id,
            letters: letterPackDisplay.letters,
            answers: answers)
    }
    
    private func fetchAnswers(letterPackID: Int) async -> [String] {
        #warning("fetch answers from api")
        return []
    }
}
