//
//  NeedToLoginView.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 12/12/23.
//

import SwiftUI

struct NeedToLoginView: View {
    @Environment(\.designTokens) var tokens
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: tokens.padding.xxs) {
                Spacer()
                
                Text("You need to login to use this feature")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .frame(width: geometry.size.width * 0.7)
                
                Text("Having an account you will be able to get coins, buy tips in game and appear on global ranking")
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
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NeedToLoginView()
}
