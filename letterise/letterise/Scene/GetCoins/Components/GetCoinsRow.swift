//
//  GetCoinsRow.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 04/12/23.
//

import SwiftUI

struct GetCoinsRow: View {
    @Environment(\.designTokens) var tokens
    
    var label: String
    var imageName: String
    
    var body: some View {
        HStack {
            DSText(label)
                .textStyle(tokens.font.title, withColor: tokens.color.label.primary)
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 70)
        }
        .padding(24)
        .background(.black.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    GetCoinsRow(label: "Get 10 free coins", imageName: "coins1")
}
