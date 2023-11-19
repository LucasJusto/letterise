//
//  KeyboardViewModel.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import Foundation

protocol KeyboardViewModelProtocol {
    func toString(chars: [Character]) -> String
    func spaceFilledArray(letters: [Character]) -> [Character]
}

final class KeyboardViewModel: KeyboardViewModelProtocol {
    func toString(chars: [Character]) -> String {
        var string: String = ""
        
        for char in chars {
            string += "\(char)"
        }
        
        return string
    }
    
    func spaceFilledArray(letters: [Character]) -> [Character] {
        var spaceFilledArray: [Character] = []
        
        for _ in letters {
            spaceFilledArray.append(" ")
        }
        
        return spaceFilledArray
    }
}
