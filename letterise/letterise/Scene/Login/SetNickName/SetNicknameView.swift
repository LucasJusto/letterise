//
//  SetNicknameView.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 09/12/23.
//

import SwiftUI

struct SetNicknameView: View {
    @Environment(\.designTokens) var tokens
    @FocusState private var isTextFieldFocused: Bool
    @State var nickname: String = ""
    @State var showAlert = false
    @State var alertTitle: String = ""
    @State var alertSubtitle: String = ""
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            VStack {
                
                Text("Need to choose an in game nickname")
                    .font(.title).bold()
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
                
                Text("This nickname will be used to save your rankings")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 56)
                
                
                TextField("Nickname", text: $nickname)
                    .focused($isTextFieldFocused)
                    .padding()
                    .background(.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                DSButton(label: "Set nickname", action: {
                    registerNickname()
                })
                .frame(height: 50)
                
            }
            .padding(.horizontal)
            if isLoading {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }
                .background(.black.opacity(0.4))
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertSubtitle),
                dismissButton: .default(Text("Ok"))
            )
        }
    }
    
    func showAlert(alertTitle: String, alertSubtitle: String) {
        self.alertTitle = alertTitle
        self.alertSubtitle = alertSubtitle
        showAlert = true
    }
    
    func registerNickname() {
        isLoading = true
        if nickname == "" {
            isLoading = false
            showAlert(alertTitle: "Empty nickname", alertSubtitle: "You need to fill the nickname field")
        } else {
            AuthSingleton.shared.registerInGameNickname(iCloudID: AuthSingleton.shared.actualUser.iCloudID, inGameNickname: nickname) { resultado in
                isLoading = false
                DispatchQueue.main.async {
                    switch resultado {
                    case .success(let status):
                        AuthSingleton.shared.actualUser.inGameNickName = nickname
                        self.handleReturn(status)
                    case .failure(let erro):
                        self.handleReturn(erro)
                    }
                }
            }
        }
    }
    
    func handleReturn(_ status: NickNameStatus) {
        
        switch status {
        case .nicknameInUse:
            showAlert(alertTitle: "Nickname in use", alertSubtitle: "You need to choose another nickname to your profile")
        case .userNotFound:
            showAlert(alertTitle: "User not found", alertSubtitle: "We cant found a user to your credentials")
        case .serverError(let string):
            showAlert(alertTitle: "Server error", alertSubtitle: "Try again later or talk with support")
        case .unknownError:
            showAlert(alertTitle: "Unknown error", alertSubtitle: "Try again later or talk with support")
        case .success:
            AuthSingleton.shared.changeAuthStatus(status: .logged)
        }
    }
}

#Preview {
    SetNicknameView()
}
