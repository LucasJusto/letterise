//
//  LetterPackView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct LetterPackView: View {
    private var viewModel: LetterPackViewModelProtocol
    
    init(letterPack: LetterPack) {
        self.viewModel = LetterPackViewModel(letterPack: letterPack)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LetterPackView(
        letterPack: try! LetterPack(
            letters: ["c", "a", "r", "o"]
            , answers: ["caro", "ar", "aro", "arco", "ra"]))
}
