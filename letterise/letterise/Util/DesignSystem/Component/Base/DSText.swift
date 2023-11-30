//
//  DSText.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//
import SwiftUI

public struct DSText: View {
    
    private let text: String
    private let multilineTextAlignment: TextAlignment
    
    public init(_ text: String, multilineTextAlignment: TextAlignment = .leading) {
        self.text = text
        self.multilineTextAlignment = multilineTextAlignment
    }
    
    public var body: some View {
        Text(LocalizedStringKey(text))
            .multilineTextAlignment(multilineTextAlignment)
    }
    
    func textStyle(_ style: FontStyle, withColor color: Color? = nil) -> some View {
        modifier(
            TextStyleModifier(style: style, customColor: color)
        )
    }
}

public struct FontStyle {
    let textStyle: Font.TextStyle
    let weight: Font.Weight
}

struct TextStyleModifier: ViewModifier {
    
    @Environment(\.designTokens) var tokens
    
    let style: FontStyle
    let customColor: Color?
    
    func body(content: Content) -> some View {
        content
            .font(.system(style.textStyle, weight: style.weight))
            .foregroundColor(customColor ?? tokens.color.label.primary)
    }
}
