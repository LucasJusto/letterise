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
        VStack(alignment: .center, spacing: tokens.padding.md) {
            Spacer()
            
            youDidItView
            
            DSButton(label: "Back to menu") {
                backToMenuAction()
            }
            .frame(height: 60)
            .padding(.bottom, tokens.padding.md)
            .padding(.horizontal, tokens.padding.sm)
        }
        .background {
            Image("CongratulationsBackground")
                .resizable()
                .scaledToFill()
                .offset(y: 50)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var youDidItView: some View {
        VStack {
            Text("You")
                .font(.system(size: 80, weight: .heavy))
            Text("did")
                .font(.system(size: 80, weight: .heavy))
            Text("it")
                .font(.system(size: 80, weight: .heavy))
        }
    }
}

#Preview {
    CongratulationsView(backToMenuAction: {})
}
