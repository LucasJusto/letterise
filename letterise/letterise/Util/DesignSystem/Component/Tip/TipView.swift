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
                    blocked: !viewModel.canAskLetterTip(),
                    processing: $viewModel.isProcessingLetterTip)
            })
            .disabled(viewModel.isProcessingLetterTip || !viewModel.canAskLetterTip())
            
            Button(action: {
                viewModel.wordsTipAction()
            }, label: {
                TipButtonView(
                    image: Image("RandomWordTip"),
                    price: viewModel.getWordsTipPrice(),
                    blocked: false,
                    processing: $viewModel.isProcessingWordTip)
            })
            .disabled(viewModel.isProcessingWordTip)
        }
        .frame(height: 50)
    }
}

#Preview {
    TipView()
}
