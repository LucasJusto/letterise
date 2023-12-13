//
//  NeedToLoginView.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 12/12/23.
//

import SwiftUI

struct NeedToLoginView: View {
    @Environment(\.designTokens) var tokens
    @Binding var isShowingNeedToLogin: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: tokens.padding.xxs) {
                Spacer()
                
                Text("Create an account to save your credits across devices")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .frame(width: geometry.size.width * 0.7)
                
                Text("You can continue without an account, but uninstalling the app or playing on another device will result in the loss of all your credits and progress in the game.")
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(tokens.color.label.secondary)
                    .frame(width: geometry.size.width * 0.7)
                
                Spacer()
                
                DSButton(label: "Create account", action: {
                    AuthSingleton.shared.changeAuthStatus(status: .needToCreateAccount)
                })
                .frame(height: 50)
                .padding(.bottom, 32)
                
                Text("I don't want to create an account")
                    .onTapGesture {
                        isShowingNeedToLogin = false
                    }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NeedToLoginView(isShowingNeedToLogin: .constant(true))
}
