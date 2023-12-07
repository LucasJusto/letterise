//
//  Font.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//
import SwiftUI

struct Fonts {
    let standard: FontStyle = FontStyle(textStyle: .body, weight: .regular)
    let standardBold: FontStyle = FontStyle(textStyle: .body, weight: .bold)
    let big: FontStyle = FontStyle(textStyle: .largeTitle, weight: .bold)
    let title: FontStyle = FontStyle(textStyle: .title, weight: .bold)
    let title2: FontStyle = FontStyle(textStyle: .title2, weight: .bold)
    let title3: FontStyle = FontStyle(textStyle: .title3, weight: .bold)
    let caption: FontStyle = FontStyle(textStyle: .caption, weight: .regular)
    let caption2: FontStyle = FontStyle(textStyle: .caption2, weight: .regular)
    let callout: FontStyle = FontStyle(textStyle: .callout, weight: .regular)
    let body: FontStyle = FontStyle(textStyle: .body, weight: .light)
}
