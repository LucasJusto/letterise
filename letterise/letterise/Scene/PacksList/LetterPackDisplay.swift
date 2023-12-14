//
//  LetterPackDisplay.swift
//  letterise
//
//  Created by Lucas Justo on 28/11/23.
//

import Foundation

struct LetterPackDisplay: Identifiable {
    let id: Int
    let letters: [Letter]
    let isFree: Bool
    var isOwned: Bool
    let price: Int
}

extension LetterPackDisplay: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
        
    public static func == (lhs: LetterPackDisplay, rhs: LetterPackDisplay) -> Bool {
        return lhs.id == rhs.id
    }
}
