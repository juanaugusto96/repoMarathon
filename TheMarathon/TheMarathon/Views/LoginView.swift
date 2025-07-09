//
//  LoginView.swift
//  TheMarathon
//
//  Created by Juan Augusto Roldan on 09/07/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showingSignUp = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Iniciar Sesión").font(.largeTitle).bold().padding(.bottom, 30)
            TextField("Email", text: $email).keyboardType(.emailAddress).autocapitalization(.none).padding().background(Color(.secondarySystemBackground)).cornerRadius(8)
            SecureField("Contraseña", text: $password).padding().background(Color(.secondarySystemBackground)).cornerRadius(8)
            
            if !authVM.errorMessage.isEmpty {
                Text(authVM.errorMessage).foregroundColor(.red).font(.caption)
            }
            
            Spacer()
            
            Button {
                authVM.login(email: email, password: password)
            } label: {
                HStack {
                    Spacer()
                    if authVM.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Iniciar Sesión").bold()
                    }
                    Spacer()
                }.padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
            }.disabled(authVM.isLoading)
            
            HStack {
                Spacer()
                Text("¿No tienes cuenta?").font(.footnote)
                Button("Regístrate") { showingSignUp = true }.tint(.blue).font(.footnote)
                Spacer()
            }
        }.padding().sheet(isPresented: $showingSignUp) { SignUpView() }
    }
}
