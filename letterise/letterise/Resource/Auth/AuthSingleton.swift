//
//  AuthSingleton.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 02/12/23.
//

import Foundation

class AuthSingleton: ObservableObject {
    static let shared = AuthSingleton()

    private init() {
    }
    
    @Published var isLogged: Bool = false
    @Published var isAuthenticating: Bool = true
    
    var actualUser: UserModel = UserModel(id: 1, iCloudID: "iCloudID", credits: 0, email: "email")

    func doAuth(email: String, userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://gpt-treinador.herokuapp.com/letterise/auth") else {
            completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "iCloudID": userId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey: "Nenhum dado recebido"])))
                return
            }
            completion(.success(responseString))
        }.resume()
    }
    
    func checkCredentials() {
        if let userCredential = UserDefaults.standard.string(forKey: "userCredential") {
            doAuth(email: "nil", userId: userCredential) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let responseString):
                    // Convertendo a string para Data
                    if let jsonData = responseString.data(using: .utf8) {
                        do {
                            // Tenta converter a resposta em um dicionário
                            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                                // Acessa o dicionário aninhado 'user'
                                if let user = json["user"] as? [String: Any] {
                                    // Extrai o email e os créditos
                                    if let email = user["email"] as? String,
                                       let credits = user["credits"] as? Int,
                                       let id = user["id"] as? Int {
                                        print("Email: \(email)")
                                        print("Id: \(id)")
                                        print("Credits: \(credits)")
                                        AuthSingleton.shared.actualUser = UserModel(id: id, iCloudID: userCredential, credits: credits, email: email)
                                        self.setIsLogged(bool: true)
                                    } else {
                                        self.setIsLogged(bool: false)
                                    }
                                } else {
                                    self.setIsLogged(bool: false)
                                }
                            } else {
                                self.setIsLogged(bool: false)
                            }
                            self.setIsAuthenticating(bool: false)
                        } catch {
                            print("Erro ao decodificar JSON: \(error)")
                            self.setIsLogged(bool: false)
                            self.setIsAuthenticating(bool: false)
                        }
                    }
                    
                    
                case .failure(let error):
                    print("Erro ao adicionar usuário: \(error.localizedDescription)")
                    setIsLogged(bool: false)
                    setIsAuthenticating(bool: false)
  }
            }
            
        } else {
            setIsAuthenticating(bool: false)
        }
    }
    
    private func setIsAuthenticating(bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isAuthenticating = bool
        }
    }
    
    private func setIsLogged(bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isLogged = bool
        }
    }
    
    func addCredits(amount: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "http://gpt-treinador.herokuapp.com/letterise/add_credits")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "iCloudID": actualUser.iCloudID,
            "credits": Int(amount) ?? 0
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            self.actualUser.credits = self.actualUser.credits + Int(amount)!

            completion(true)
        }

        task.resume()
    }
}
