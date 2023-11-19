//
//  DSButton.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI

struct DSButton: View {
    @Environment(\.designTokens) var tokens
    
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: tokens.borderRadius.md)
                    .foregroundStyle(tokens.color.background.counterPrimary)
                
                DSText(label)
                    .textStyle(
                        tokens.font.standard,
                               withColor: tokens.color.label.counterPrimary)
            }
        })
    }
}

#Preview {
    DSButton(label: "Try word") {
        print("Tried!")
    }
}
