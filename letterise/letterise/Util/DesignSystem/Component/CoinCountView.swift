//
//  CoinCountView.swift
//  letterise
//
//  Created by Lucas Justo on 07/12/23.
//

import SwiftUI

struct CoinCountView: View {
    @Environment(\.designTokens) var tokens
    
    let count: Int
    
    var body: some View {
        HStack(spacing: tokens.padding.xquarck) {
            Image("coin")
                .resizable()
                .frame(width: 20, height: 20)
            
            DSText("\(count)")
                .textStyle(tokens.font.standardBold, withColor: tokens.color.label.primary)
        }
        
    }
}

#Preview {
    CoinCountView(count: 10)
}
