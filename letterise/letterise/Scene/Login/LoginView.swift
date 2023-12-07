//
//  LoginView.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 25/11/23.
//

import SwiftUI
import AuthenticationServices

class AppleSignInManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    var onAuthorizationComplete: ((String) -> Void)?

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            UserDefaults.standard.set(appleIDCredential.user, forKey: "userCredential")
            AuthSingleton.shared.doAuth(userId: appleIDCredential.user) { result in
                switch result {
                case .success(let responseString):
                    // Convertendo a string para Data
                    if let jsonData = responseString.data(using: .utf8) {
                        do {
                            // Tenta converter a resposta em um dicionário
                            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                                // Acessa o dicionário aninhado 'user'
                                if let user = json["user"] as? [String: Any] {
                                    if let credits = user["credits"] as? Int {
                                        print("Credits: \(credits)")
                                    }
                                }
                            }
                        } catch {
                            print("Erro ao decodificar JSON: \(error)")
                        }
                    }
                    self.onAuthorizationComplete?(appleIDCredential.user)

                case .failure(let error):
                    print("Erro ao adicionar usuário: \(error.localizedDescription)")
                    self.onAuthorizationComplete?(appleIDCredential.user)
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Lidar com erro
        onAuthorizationComplete?("no")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Retornar a janela de apresentação adequada
        return UIApplication.shared.windows.first!
    }
    
}

struct LoginView: View {
    private let signInManager = AppleSignInManager()
    
    @State var showAlert = false
    @Binding var isAuthenticated: Bool

    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            Image(systemName: "icloud")
                .font(.system(size: 120, weight: .regular))
                .padding(.bottom, 32)
            Text("We will save your game progress")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
                .frame(width: UIScreen.main.bounds.width * 0.5)
            Text("Your data in this app will be related to your iCloud ID to make possible accessing it in other devices")
                .font(.system(size: 12, weight: .light))
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
                .frame(width: UIScreen.main.bounds.width * 0.6)
            
            Spacer()
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "apple.logo")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.white)
                    .padding(.trailing, 4)
                Text("Login with Apple")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.vertical, 16)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 16)
            .onTapGesture {
                performAppleSignIn()
            }
            .padding(.bottom, 32)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Login error"),
                    message: Text("You need to login in with iCLoud to continue"),
                    dismissButton: .default(Text("Ok"))
                )
            }
            .onAppear {
                performAppleSignIn()
            }
        }
    }

    private func performAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = signInManager
        authorizationController.presentationContextProvider = signInManager
        authorizationController.performRequests()

        signInManager.onAuthorizationComplete = { response in
            if response != "no" {
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            } else {
                print("Erro")
                DispatchQueue.main.async {
                    self.showAlert = true
                }
                
            }
        }
    }
}



#Preview {
    LoginView(isAuthenticated: .constant(false))
}
