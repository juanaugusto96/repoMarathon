//
//  ContentView.swift
//  TheMarathon
//
//  Created by Juan Augusto Roldan on 09/07/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        if authVM.firebaseUser != nil {
            HomeView()
        } else {
            LoginView()
        }
    }
}
