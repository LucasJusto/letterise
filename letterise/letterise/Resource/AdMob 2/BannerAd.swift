//
//  BannerAd.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 05/12/23.
//

import Foundation
import SwiftUI
import GoogleMobileAds

class AdMobService {
    
    static var instance: AdMobService = AdMobService()

    let get10FreeCoins = "ca-app-pub-7490663355066325/4568653596"
    let test = "ca-app-pub-7490663355066325/4568653596"
    let list = "ca-app-pub-7490663355066325/2912845046"
    
}

struct BannerAd: UIViewRepresentable {
    
    @State var height: CGFloat = 50 //Height of ad
    @State var width: CGFloat = 0 //Width of ad
    var unitID: String

    func makeCoordinator() -> Coordinator {
        // For Implementing Delegates..
        return Coordinator()
    }

    func makeUIView(context: Context) -> GADBannerView{
        let adView = GADBannerView(adSize: GADAdSizeBanner)
        
        adView.adUnitID = unitID
        adView.rootViewController = UIApplication.shared.getRootViewController()

        adView.load(GADRequest())

        return adView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {

    }

    class Coordinator: NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("bannerViewDidReceiveAd")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            print("bannerViewDidDismissScreen")
        }
    }
}

// Extending Application to get RootView..
extension UIApplication {
    func getRootViewController() -> UIViewController {

        guard let screen = self.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }

        return root
    }
}

