//
//  letteriseApp.swift
//  letterise
//
//  Created by Lucas Justo on 18/11/23.
//

import SwiftUI
import GoogleMobileAds

class AppDelegate:NSObject,UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}

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
