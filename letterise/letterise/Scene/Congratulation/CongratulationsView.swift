//
//  CongratulationsView.swift
//  letterise
//
//  Created by Lucas Justo on 24/11/23.
//

import SwiftUI

struct CongratulationsView: View {
    @Environment(\.designTokens) var tokens
    
    let backToMenuAction: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: tokens.padding.xs) {
                Spacer()
                youDidItView
                    .padding(.top, tokens.padding.sm)
                
                DSButton(label: "Back to menu") {
                    backToMenuAction()
                }
                .frame(height: 60)
                .padding(.bottom, tokens.padding.sm)
                .padding(.horizontal, tokens.padding.sm)
                Spacer()
            }
            Spacer()
        }
        .background {
            LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .bottomLeading, endPoint: .topTrailing)
                .ignoresSafeArea()
        }
    }
    
    private var youDidItView: some View {
        VStack {
            Text("You")
                .font(.system(size: 55, weight: .heavy))
            Text("did")
                .font(.system(size: 55, weight: .heavy))
            Text("it")
                .font(.system(size: 55, weight: .heavy))
        }
    }
}

#Preview {
    CongratulationsView(backToMenuAction: {})
}
