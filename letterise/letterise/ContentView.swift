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
            switch authManager.authenticationStatus {
            case .dontHaveInGameNickName:
                SetNicknameView()
            case .logged:
                PacksListView()
            case .invalidURL:
                LoginView(isAuthenticated: $authManager.isLogged)
            case .error:
                LoginView(isAuthenticated: $authManager.isLogged)
            case .inauthenticated:
                LoginView(isAuthenticated: $authManager.isLogged)
            case .authenticating:
                ProgressView()
            }
        }
    }
}

#Preview {
    ContentView()
}
