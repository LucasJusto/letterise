//
//  ContentView.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authManager = AuthSingleton.shared
    
    init() {
        authManager.checkCredentials()
    }
    
    var body: some View {
        ZStack {
            if authManager.isAuthenticating {
                ProgressView()
            } else {
                if authManager.isLogged {
                    PacksListView()
//                    LetterPackView(
//                        letterPack: try! LetterPack(
//                            letters: [Letter(char: "c"), Letter(char: "a"), Letter(char: "r"), Letter(char: "o")],
//                            answers: ["caro", "ar", "aro", "arco", "ra"]))
                } else {
                    LoginView(isAuthenticated: $authManager.isLogged)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
