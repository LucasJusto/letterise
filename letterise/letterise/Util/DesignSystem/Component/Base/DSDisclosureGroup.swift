//
//  DSDisclosureGroup.swift
//  letterise
//
//  Created by Lucas Justo on 28/11/23.
//

import SwiftUI

struct DSDisclosureGroup<Content: View>: View {
    @Environment(\.designTokens) var tokens
    
    let title: String
    
    @ViewBuilder let content: Content
    @State var isExpanded: Bool

    

    init(_ title: String,
         isExpanded: Bool = false,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self._isExpanded = State(initialValue: isExpanded)
        self.content = content()
    }
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            content
        } label: {
            HStack(spacing: tokens.padding.quarck) {
                DSText(title.capitalized)
                    .textStyle(tokens.font.title2, withColor: tokens.color.label.primary)
                    .padding(.bottom, tokens.padding.nano)
                
                Text(Image(systemName: isExpanded ? "chevron.down" : "chevron.left"))
                    .foregroundStyle(tokens.color.label.primary)
                    .font(.title3)
                    .fontWeight(.bold)
                    .offset(y: -2)
            }
        }
    }
}

//#Preview {
//    DSDisclosureGroup()
//}
