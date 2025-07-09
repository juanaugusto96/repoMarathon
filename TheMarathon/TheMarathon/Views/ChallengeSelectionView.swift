//
//  ChallengeSelectionView.swift
//  TheMarathon
//
//  Created by Juan Augusto Roldan on 09/07/2025.
//

import SwiftUI

struct ChallengeSelectionView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    private let challenges: [Double] = [20, 40, 60]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Elige tu Desafío Semanal").font(.largeTitle).fontWeight(.bold).padding(.bottom, 30)
                ForEach(challenges, id: \.self) { challengeKm in
                    Button {
                        authVM.updateWeeklyChallenge(goalInKm: challengeKm)
                        dismiss()
                    } label: {
                        Text("\(Int(challengeKm)) km / semana").font(.title2).fontWeight(.semibold).frame(maxWidth: .infinity)
                            .padding().background(Color.blue).foregroundColor(.white).cornerRadius(12)
                    }
                }
                Spacer()
            }
            .padding().navigationBarTitle("Desafíos", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
            }
        }
    }
}
