//
//  RankingModel.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 11/12/23.
//

import Foundation

struct Ranking: Codable, Identifiable {
    let id = UUID()
    var inGameNickname: String
    var rankingCount: Int

    enum CodingKeys: String, CodingKey {
        case inGameNickname = "inGameNickname"
        case rankingCount = "rankingCount"
    }
}
