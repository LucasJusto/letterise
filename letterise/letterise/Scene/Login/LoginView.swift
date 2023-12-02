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
            if let userEmail = appleIDCredential.email {
                UserDefaults.standard.set(userEmail, forKey: "email")
            }
            AuthSingleton.shared.doAuth(email: UserDefaults.standard.string(forKey: "email") ?? "nil", userId: appleIDCredential.user) { result in
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
                                    if let email = user["email"] as? String, let credits = user["credits"] as? Int {
                                        print("Email: \(email)")
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
            Text("Vamos salvar seu progresso no jogo")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
                .frame(width: UIScreen.main.bounds.width * 0.5)
            Text("Seus dados são salvos com iCloud para você acessar em outros dispositivos")
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
                Text("Login com Apple")
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
            .padding(.bottom, 24)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Erro de login"),
                    message: Text("Você precisa fazer login com iCloud para continuar"),
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
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = signInManager
        authorizationController.presentationContextProvider = signInManager
        authorizationController.performRequests()

        signInManager.onAuthorizationComplete = { response in
            if response != "no" {
                self.isAuthenticated = true
            } else {
                print("Erro")
                showAlert = true
            }
        }
    }
}



#Preview {
    LoginView(isAuthenticated: .constant(false))
}
