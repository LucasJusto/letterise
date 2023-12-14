//
//  AuthSingleton.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 02/12/23.
//

import Foundation

public enum AuthStatus: Error {
    case dontHaveInGameNickName
    case logged
    case error
    case invalidURL
    case inauthenticated
    case authenticating
    case needToCreateAccount
}

enum NickNameStatus: Error {
    case nicknameInUse
    case userNotFound
    case serverError(String)
    case unknownError
    case success
}


class AuthSingleton: ObservableObject {
    static let shared = AuthSingleton()
    
    private init() {}
    
    @Published var isLogged: Bool = false
    @Published var isAuthenticating: Bool = true
    @Published var authenticationStatus: AuthStatus = .authenticating
    let url = "http://gpt-treinador.herokuapp.com"
    
    var actualUser: UserModel = UserModel(id: 1, iCloudID: "iCloudID", credits: 0)
    
    func changeAuthStatus(status: AuthStatus) {
        DispatchQueue.main.async {
            AuthSingleton.shared.authenticationStatus = status
        }
    }
    
    func doAuth(icloudID: String, completion: @escaping (AuthStatus) -> Void) {
        guard let url = URL(string: "\(url)/letterise/auth") else {
            completion(.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(icloudID)
        
        var body: [String: Any]?
        let actualCredits = UserDefaults.standard.integer(forKey: "credits")

        if actualCredits != 0 {
            body = ["iCloudID": icloudID, "credits": actualCredits]
        } else {
            body = ["iCloudID": icloudID]
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: body as Any, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.error)
                return
            }
            
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                // nao veio data
                completion(.error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let jsonData = responseString.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            if let user = json["user"] as? [String: Any] {
                                if let credits = user["credits"] as? Int,
                                   let id = user["id"] as? Int,
                                   let inGameNickname = user["inGameNickname"] as? String {
                                    AuthSingleton.shared.actualUser = UserModel(id: id, iCloudID: icloudID, credits: credits, inGameNickName: inGameNickname)
                                    self.changeAuthStatus(status: .logged)
                                    completion(.logged)
                                } else {
                                    self.changeAuthStatus(status: .error)
                                    completion(.error)
                                }
                            } else {
                                self.changeAuthStatus(status: .error)
                                completion(.error)
                            }
                        } else {
                            self.changeAuthStatus(status: .error)
                            completion(.error)
                        }
                    } catch {
                        self.changeAuthStatus(status: .error)
                        print("Erro ao decodificar JSON: \(error)")
                        completion(.error)
                    }
                }
                completion(.error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 400 {
                self.changeAuthStatus(status: .dontHaveInGameNickName)
                completion(.dontHaveInGameNickName)
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                if let jsonData = responseString.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            if let user = json["user"] as? [String: Any] {
                                if let credits = user["credits"] as? Int,
                                   let id = user["id"] as? Int {
                                    print("Id: \(id)")
                                    print("Credits: \(credits)")
                                    AuthSingleton.shared.actualUser = UserModel(id: id, iCloudID: icloudID, credits: credits)
                                    self.changeAuthStatus(status: .dontHaveInGameNickName)
                                    completion(.dontHaveInGameNickName)
                                } else {
                                    self.changeAuthStatus(status: .error)
                                    completion(.error)
                                }
                            } else {
                                self.changeAuthStatus(status: .error)
                                completion(.error)
                            }
                        } else {
                            self.changeAuthStatus(status: .error)
                            completion(.error)
                        }
                        self.changeAuthStatus(status: .error)
                        completion(.error)
                    } catch {
                        self.changeAuthStatus(status: .error)
                        print("Erro ao decodificar JSON: \(error)")
                        completion(.error)
                    }
                }
                //requisicao invalida
                self.changeAuthStatus(status: .error)
                completion(.error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 500 {
                self.changeAuthStatus(status: .error)
                completion(.error)
            }
        }.resume()
    }
    
    func checkCredentials() {
        if let userCredential = UserDefaults.standard.string(forKey: "userCredential") {
            doAuth(icloudID: userCredential) { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .dontHaveInGameNickName:
                    print("precisa cadastrar username")
                case .logged:
                    print("fez login")
                case .invalidURL:
                    print("invalid URL")
                case .error:
                    print("Erro na autenticacao")
                case .inauthenticated:
                    print("ainda não autenticou")
                case .authenticating:
                    print("autenticando")
                case .needToCreateAccount:
                    print("precisa criar conta")
                }
            }
            
        } else {
            self.changeAuthStatus(status: .inauthenticated)
            changeCredits(amount: UserDefaults.standard.integer(forKey: "credits"))
            
        }
    }
    
    func registerInGameNickname(iCloudID: String, inGameNickname: String, completion: @escaping (Result<NickNameStatus, NickNameStatus>) -> Void) {
        guard let url = URL(string: "\(url)/letterise/register-nickname") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["iCloudID": UserDefaults.standard.string(forKey: "userCredential") ?? "", "inGameNickname": inGameNickname]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknownError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }

            switch httpResponse.statusCode {
            case 200:
                completion(.success(.success))
            case 400:
                guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                    completion(.failure(.unknownError))
                    return
                }
                if let jsonData = responseString.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            if json["error"] as? String == "inGameNickname already in use." {
                                completion(.success(.nicknameInUse))
                            } else {
                                completion(.failure(.unknownError))
                            }
                        } else {
                            completion(.failure(.unknownError))
                        }
                    } catch {
                        print("Erro ao decodificar JSON: \(error)")
                        completion(.failure(.unknownError))
                    }
                }
            case 404:
                completion(.failure(.userNotFound))
            case 500:
                let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(.serverError(errorMessage)))
            default:
                completion(.failure(.unknownError))
            }
        }.resume()
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
    
    func changeCredits(amount: Int) {
        DispatchQueue.main.async {
            self.actualUser.credits = amount
        }
    }
    
    func addCredits(amount: String, completion: @escaping (Bool) -> Void) {
        
        if authenticationStatus == .inauthenticated {
            let actualCredits = UserDefaults.standard.integer(forKey: "credits")
            UserDefaults.standard.setValue(actualCredits + (Int(amount) ?? 0), forKey: "credits")
            changeCredits(amount: UserDefaults.standard.integer(forKey: "credits"))
            completion(true)
        } else {
            
            let url = URL(string: "http://gpt-treinador.herokuapp.com/letterise/add_credits")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "userID": "\(actualUser.id)",
                "credits": amount
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(false)
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let newCredits = jsonResponse["new_credits"] as? Int {
                        self.changeCredits(amount: newCredits)
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    completion(false)
                }
            }
            
            task.resume()
        }
    }
    
    func spendCredits(amount: String, completion: @escaping (Bool) -> Void) {
        
        if authenticationStatus == .inauthenticated {
            let actualCredits = UserDefaults.standard.integer(forKey: "credits")
            if actualCredits >= Int(amount) ?? 0 {
                UserDefaults.standard.setValue(actualCredits - (Int(amount) ?? 0), forKey: "credits")
                changeCredits(amount: UserDefaults.standard.integer(forKey: "credits"))
                completion(true)
            } else {
                completion(false)
            }
        } else {
            let url = URL(string: "http://gpt-treinador.herokuapp.com/letterise/subtract_credits")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "userID": "\(actualUser.id)",
                "credits": amount
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(false)
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let newCredits = jsonResponse["new_credits"] as? Int {
                        self.changeCredits(amount: newCredits)
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    completion(false)
                }
            }
            
            task.resume()
        }
    }
}
