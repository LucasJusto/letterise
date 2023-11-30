//
//  LetteriseTopView.swift
//  letterise
//
//  Created by Lucas Justo on 26/11/23.
//

import SwiftUI

struct LetteriseTopView: View {
    @Environment(\.designTokens) var tokens
    
    var body: some View {
        ZStack {
            Image("LetteriseBackground")
                .resizable()
                .frame(height: 150)
                .padding(.horizontal, tokens.padding.xxxs)
            
            DSText("letterise")
                .textStyle(tokens.font.big, withColor: tokens.color.label.counterPrimary)
        }
        
    }
}

#Preview {
    LetteriseTopView()
}
