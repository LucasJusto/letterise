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
            doAuth(email: "nil", userId: userCredential) { result in
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
                                        self.isLogged = true
                                        self.isAuthenticating = false
                                    } else {
                                        self.isLogged = false
                                        self.isAuthenticating = false
                                    }
                                } else {
                                    self.isLogged = false
                                    self.isAuthenticating = false
                                }
                            } else {
                                self.isLogged = false
                                self.isAuthenticating = false
                            }
                        } catch {
                            print("Erro ao decodificar JSON: \(error)")
                            self.isLogged = false
                            self.isAuthenticating = false
                        }
                    }
                    
                    
                case .failure(let error):
                    print("Erro ao adicionar usuário: \(error.localizedDescription)")
                    self.isLogged = false
                    self.isAuthenticating = false
                    
                }
            }
            
        } else {
            isAuthenticating = false
        }
    }
}
