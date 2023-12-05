//
//  RewardedAd.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 05/12/23.
//

import Foundation
import GoogleMobileAds

class RewardAdsManager: NSObject,GADFullScreenContentDelegate,ObservableObject{
    
    // Properties
    @Published var rewardLoaded:Bool = false
    var rewardAd: GADRewardedAd?
//    var unitID: String?
    
    override init() {
        super.init()
    }
    
    // Load reward ads
    func loadReward(unitIDRewarded: String){
//        self.unitID = unitIDRewarded
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-7490663355066325/5563005216", request: GADRequest()) { add, error in
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
            print("deu erro")
            return
        }
        print("fora")
        if let ad = rewardAd{
            ad.present(fromRootViewController: root) {
                #warning("give coins to user")
                print("🟢: Earned a reward")
                self.rewardLoaded = false
            }
        } else {
            print("🔵: Ad wasn't ready")
            self.rewardLoaded = false
            self.loadReward(unitIDRewarded: "ca-app-pub-7490663355066325/5563005216")
        }
    }
}
