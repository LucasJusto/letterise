//
//  ContentView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            LetterPackView(
                letterPack: try! LetterPack(
                    letters: [Letter(char: "c"), Letter(char: "a"), Letter(char: "r"), Letter(char: "o")],
                    answers: ["caro", "ar", "aro", "arco", "ra"]))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
