//
//  letteriseApp.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI
import GoogleMobileAds

@main
struct letteriseApp: App {
    @State var tokens: Tokens = Tokens()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea()
                .environment(\.designTokens, tokens)
        }
    }
}

public struct DesignTokensKey: EnvironmentKey {
    public static let defaultValue: Tokens = Tokens()
}

public extension EnvironmentValues {
    var designTokens: Tokens {
        get { self[DesignTokensKey.self] }
        set { self[DesignTokensKey.self] = newValue }
    }
}
