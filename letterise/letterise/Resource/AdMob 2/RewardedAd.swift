//
//  RewardedAd.swift
//  generateDisney3Dstyle
//
//  Created by Marcelo Diefenbach on 23/11/23.
//

import Foundation
import GoogleMobileAds

class RewardAdsManager: NSObject,GADFullScreenContentDelegate,ObservableObject{
    
    // Properties
    @Published var rewardLoaded:Bool = false
    var rewardAd:GADRewardedAd?
    
    override init() {
        super.init()
    }
    
    // Load reward ads
    func loadReward(){
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-7490663355066325/4568653596", request: GADRequest()) { add, error in
            if let error  = error {
                print("🔴: \(error.localizedDescription)")
                self.rewardLoaded = false
                return
            }
            print("🟢: Loading succeeded")
            self.rewardLoaded = true
            self.rewardAd = add
            self.rewardAd?.fullScreenContentDelegate = self
        }
    }
    
    // Display reward ads
    func displayReward(){
        guard let root = UIApplication.shared.windows.first?.rootViewController else {
            print("Nao abriu o anuncio")
            return
        }
        
        if let ad = rewardAd{
            ad.present(fromRootViewController: root) {
                AuthSingleton.shared.addCredits(amount: "10") { result in
                    print(result)
                }
                print("🟢: Earned a reward")
                self.rewardLoaded = false
            }
        } else {
            print("🔵: Ad wasn't ready")
            self.rewardLoaded = false
            self.loadReward()
        }
    }
}
