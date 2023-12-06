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
                } else {
                    LoginView(isAuthenticated: $authManager.isLogged)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
