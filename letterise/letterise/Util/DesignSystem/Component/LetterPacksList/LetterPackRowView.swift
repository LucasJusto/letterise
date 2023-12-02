//
//  LetterPackRowView.swift
//  letterise
//
//  Created by Lucas Justo on 28/11/23.
//

import SwiftUI

struct LetterPackRowView: View {
    @Environment(\.designTokens) var tokens
    
    let letterPack: LetterPackDisplay
    
    var body: some View {
        ZStack {
            HStack(spacing: 4) {
                Spacer()
                ForEach(0..<letterPack.letters.count, id: \.self) { index in
                    KeyboardLetterView(letter: letterPack.letters[index])
                }
                .padding(.vertical, 16)
                Spacer()
            }
        }
        .background {
            LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .bottomLeading, endPoint: .topTrailing)
        }
//        .background(.black)
//        .background {
//            Image("KeyboardBackground")
//                .resizable()
//                .scaledToFill()
//                .frame(maxWidth: .infinity)
//        }
        .frame(maxWidth: UIScreen.main.bounds.width)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    LetterPackRowView(letterPack: LetterPackDisplay(id: 0, letters: Word(word: "amanco").word, isFree: true, isOwned: true, price: 5))
}
