//
//  HomeViewModel.swift
//  letterise
//
//  Created by Lucas Justo on 11/12/23.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var isShowingGetCoinsView = false
    @Published var isShowingPacksListView = false
    @Published var isShowingRankingView = false
    @Published var isShowingSettingsView = false
    
    func setIsShowingGetCoinsView(bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isShowingGetCoinsView = bool
        }
    }
    
    func setIsShowingPacksListView(bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isShowingPacksListView = bool
        }
    }
    
    func setIsShowingRankingView(bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isShowingRankingView = bool
        }
    }
    
    func setIsShowingSettingsView(bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isShowingSettingsView = bool
        }
    }
}
