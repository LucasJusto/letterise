//
//  LetteriseTopView.swift
//  letterise
//
//  Created by Lucas Justo on 26/11/23.
//

import SwiftUI

struct LetteriseTopView: View {
    @Environment(\.designTokens) var tokens
    
    let openGetCoins: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.35)
                .background(
                    Image("LetteriseBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                )
            
            HStack(spacing: 8) {
                Image("coin")
                    .resizable()
                    .frame(width: 20, height: 20)
                DSText("\(AuthSingleton.shared.actualUser.credits)")
                    .textStyle(tokens.font.title, withColor: tokens.color.label.counterPrimary)
                DSText("Get more coins")
                    .textStyle(tokens.font.caption2, withColor: tokens.color.label.primary)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 500))
                    .onTapGesture {
                        openGetCoins()
                    }
            }
            .padding(.top, 24)
        }
    }
}

#Preview {
    LetteriseTopView(openGetCoins: {})
}
