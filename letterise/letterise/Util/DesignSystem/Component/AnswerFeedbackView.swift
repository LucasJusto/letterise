//
//  AnswerFeedbackView.swift
//  letterise
//
//  Created by Lucas Justo on 21/11/23.
//

import SwiftUI

struct AnswerFeedbackView: View {
    @Environment(\.designTokens) var tokens
    
    let title: String
    let message: String
    let height: CGFloat = 100
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: tokens.borderRadius.md)
                .stroke(tokens.color.border.primary, lineWidth: tokens.border.md)
                .frame(height: height)
                .foregroundStyle(tokens.color.background.primary)
                
            
            VStack(spacing: tokens.padding.quarck) {
                DSText(title)
                    .textStyle(tokens.font.title, withColor: tokens.color.label.primary)
                
                DSText(message, multilineTextAlignment: .center)
                    .textStyle(tokens.font.standard, withColor: tokens.color.label.primary)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: tokens.borderRadius.md)
                .foregroundColor(tokens.color.background.primary)
        }
        .padding(.horizontal, tokens.padding.xs)
    }
}

#Preview {
    AnswerFeedbackView(title: "Correct", message: "You found a word!")
}
