//
//  PacksListViewModel.swift
//  letterise
//
//  Created by Lucas Justo on 28/11/23.
//

import Foundation

final class PacksListViewModel: ObservableObject {
    @Published var packsDict: [String: [LetterPackDisplay]] = [:]
    @Published var isLoadingAnswers = false
    @Published var isShowingPlayView = false
    @Published var isShowingGetCoinsView = false
    @Published var chosenLetterPack: LetterPack? = nil
    
    var url: String = "https://gpt-treinador.herokuapp.com"
    
    func fetchPacks() {
        fetchLetterPacks(iCloudID: AuthSingleton.shared.actualUser.iCloudID) { [weak self] result in
            switch result {
            case .success(let letterPacksGrouped):
                DispatchQueue.main.async {
                    // Aqui, você pode ajustar as chaves conforme necessário.
                    self?.packsDict = [
                        "packs with 4 letters": letterPacksGrouped["pack with 4 letters"] ?? [],
                        "packs with 5 letters": letterPacksGrouped["pack with 5 letters"] ?? [],
                        "packs with 6 letters": letterPacksGrouped["pack with 6 letters"] ?? []
                    ]
                }
            case .failure(let error):
                print("Error fetching letter packs: \(error)")
                // Aqui, você pode lidar com o erro conforme necessário.
            }
        }
    }
    
    private func fetchLetterPacks(iCloudID: String, completion: @escaping (Result<[String: [LetterPackDisplay]], Error>) -> Void) {
        let url = URL(string: "\(url)/letterise/getAllByUser")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["userID": iCloudID]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    var letterPacksDict: [String: [LetterPackDisplay]] = [:]

                    for (key, value) in jsonResult {
                        if let packArray = value as? [[String: Any]] {
                            
                            let letterPacks = packArray.compactMap { packDict -> LetterPackDisplay? in
                                guard let id = packDict["id"] as? Int,
                                      let lettersString = packDict["letters"] as? String,
                                      let isFree = packDict["isFree"] as? Bool,
                                      let isOwned = packDict["isOwned"] as? Bool,
                                      let price = packDict["price"] as? Int else {
                                          return nil
                                      }
                                let letters = lettersString.enumerated().map { Letter(id: $0.offset, char: $0.element) }
                                return LetterPackDisplay(id: id, letters: letters, isFree: isFree, isOwned: isOwned, price: price)
                            }
                            letterPacksDict[key] = letterPacks
                        }
                    }
                    completion(.success(letterPacksDict))
                } else {
                    completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
    func getLetterPack(from letterPackDisplay: LetterPackDisplay) async -> Result<LetterPack, Error> {
        do {
            let result = await fetchAnswers(letterPackID: letterPackDisplay.id)
            switch result {
            case .success(let answers):
                let letterPack = try LetterPack(
                    id: letterPackDisplay.id,
                    letters: letterPackDisplay.letters,
                    answers: answers
                )
                return .success(letterPack)
            case .failure(let error):
                return .failure(error)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func navigateToLetterPackView(letterPackDisplay: LetterPackDisplay) {
        setChosenLetterPack(letterpackDisplay: letterPackDisplay)
        setIsShowingPlayView(bool: true)
    }
    
    private func setChosenLetterPack(letterpackDisplay: LetterPackDisplay) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.chosenLetterPack = LetterPack(id: letterpackDisplay.id, letters: letterpackDisplay.letters)
        }
    }
    
    private func setIsLoadingAnswers(bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isLoadingAnswers = bool
        }
    }
    
    private func setIsShowingPlayView(bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isShowingPlayView = bool
        }
    }
    
    private func fetchAnswers(letterPackID: Int) async -> Result<[String], Error> {
        guard let url = URL(string: "\(url)/letterise/getAnswers?letterPackID=\(letterPackID)") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let answers = jsonResponse["answers"] as? [[String: Any]] {
                let extractedAnswers = answers.compactMap { $0["answer"] as? String }
                return .success(extractedAnswers)
            } else {
                return .failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"]))
            }
        } catch {
            return .failure(error)
        }
    }
}
