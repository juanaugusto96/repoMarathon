//
//  SignUpView.swift
//  TheMarathon
//
//  Created by Juan Augusto Roldan on 09/07/2025.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Crear Cuenta").font(.largeTitle).bold().padding(.bottom)
            TextField("Nombre", text: $name).padding().background(Color(.secondarySystemBackground)).cornerRadius(8)
            TextField("Email", text: $email).keyboardType(.emailAddress).autocapitalization(.none).padding().background(Color(.secondarySystemBackground)).cornerRadius(8)
            SecureField("Contraseña", text: $password).padding().background(Color(.secondarySystemBackground)).cornerRadius(8)
            
            if !authVM.errorMessage.isEmpty {
                Text(authVM.errorMessage).foregroundColor(.red).font(.caption)
            }
            
            Spacer()
            
            Button {
                authVM.signUp(name: name, email: email, password: password) { success in
                    if success { dismiss() }
                }
            } label: {
                HStack {
                    Spacer()
                    if authVM.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Registrarse").bold()
                    }
                    Spacer()
                }.padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
            }.disabled(authVM.isLoading)
        }.padding()
    }
}
