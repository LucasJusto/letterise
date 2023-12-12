//
//  RankingViewModel.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 11/12/23.
//

import Foundation

final class RankingViewModel: ObservableObject {
    
    var url: String = "https://gpt-treinador.herokuapp.com"
    
    @Published var rankings: [Ranking] = []
    
    func fetchRankingList(completion: @escaping (Result<[Ranking], Error>) -> Void) {
        if AuthSingleton.shared.authenticationStatus == .logged {
            let url = URL(string: "\(url)/letterise/ranking-list")!

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                    return
                }

                do {
                    let rankings = try JSONDecoder().decode([Ranking].self, from: data)
                    print(rankings)
                    completion(.success(rankings))
                    DispatchQueue.main.sync {
                        self.rankings = rankings
                    }
                } catch {
                    completion(.failure(error))
                }
            }

            task.resume()
        }
    }
}
