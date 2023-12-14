//
//  Colors.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//
import SwiftUI

struct Colors {
    let background: Background = Background()
    let border: BorderColor = BorderColor()
    let label: LabelColor = LabelColor()
}

struct Background {
    let primary: Color = .white
    let counterPrimary: Color = .black
}

struct BorderColor {
    let primary: Color = .black
}

struct LabelColor {
    let primary: Color = .black
    let counterPrimary: Color = .white
    let secondary: Color = .gray
}
