//
//  SettingsView.swift
//  letterise
//
//  Created by Marcelo Diefenbach on 11/12/23.
//

import SwiftUI

struct SettingsView: View {
    @State var isShowingAlert = false
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Delete account")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .onTapGesture {
                    isShowingAlert = true
                }
            } header: {
                Text("Account")
            }
        }
        .navigationTitle("Settings")
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Delete account"),
                message: Text("Your data will be completely deleted in 2 business days."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    SettingsView()
}
