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
            HStack {
                
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.35)
                .background(
                    Image("LetteriseBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                )
            
            DSText("letterise")
                .textStyle(tokens.font.big, withColor: tokens.color.label.counterPrimary)
                .padding(.top, tokens.padding.xxxs)
        }
    }
}

#Preview {
    LetteriseTopView()
}
