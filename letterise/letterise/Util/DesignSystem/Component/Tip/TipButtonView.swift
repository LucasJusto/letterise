//
//  SwiftUIView.swift
//  letterise
//
//  Created by Lucas Justo on 07/12/23.
//

import SwiftUI

struct TipButtonView: View {
    @Environment(\.designTokens) var tokens
    
    let image: Image
    let price: Int
    
    @Binding var processing: Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: tokens.padding.micro) {
                image
                    .resizable()
                    .frame(width: 40, height: 40)
                
                CoinCountView(count: price)
                    .padding(.trailing, tokens.padding.quarck)
            }
            .padding(tokens.padding.nano)
            .background {
                RoundedRectangle(cornerRadius: tokens.borderRadius.md)
                    .foregroundStyle(tokens.color.background.counterPrimary.opacity(0.1))
            }
            .opacity(processing ? 0.5 : 1)
            
            if processing {
                ProgressView()
            }
        }
        
    }
}

#Preview {
    TipButtonView(image: Image("RandomLetterTip"), price: 20, processing: .constant(false))
}
