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
                showNeedToLoginView()
            }, label: {
                TipButtonView(
                    image: Image("RandomLetterTip"),
                    price: viewModel.getLettersTipPrice(),
                    blocked: !viewModel.canAskLetterTip(),
                    processing: $viewModel.isProcessingLetterTip)
            })
            .disabled(viewModel.isProcessingLetterTip || !viewModel.canAskLetterTip())
            
            Button(action: {
                showNeedToLoginView()
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
    
    func showNeedToLoginView() {
        DispatchQueue.main.async {
            if AuthSingleton.shared.authenticationStatus == .inauthenticated {
                viewModel.isPresentingNeedToLoginView = true
            } else {
                viewModel.lettersTipAction()
            }
        }
    }
}

#Preview {
    TipView()
}
