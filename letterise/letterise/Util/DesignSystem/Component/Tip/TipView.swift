//
//  TipView.swift
//  letterise
//
//  Created by Lucas Justo on 07/12/23.
//

import SwiftUI

struct TipView: View {
    @Environment(\.designTokens) var tokens
    @EnvironmentObject var viewModel: LetterPackViewModel
    
    var body: some View {
        HStack(spacing: tokens.padding.micro) {
            Button(action: {
                viewModel.lettersTipAction()
            }, label: {
                TipButtonView(
                    image: Image("RandomLetterTip"),
                    price: viewModel.getLettersTipPrice(),
                    processing: $viewModel.isProcessingLetterTip)
            })
            .disabled(viewModel.isProcessingLetterTip)
            
            #warning("based on words left")
            Button(action: {
                print("word")
            }, label: {
                TipButtonView(
                    image: Image("RandomWordTip"),
                    price: 10,
                    processing: .constant(false))
            })
            
            
        }
        .frame(height: 50)
    }
}

#Preview {
    TipView()
}
