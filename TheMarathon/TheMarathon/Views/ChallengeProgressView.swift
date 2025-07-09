//
//  ChallengeProgressView.swift
//  TheMarathon
//
//  Created by Juan Augusto Roldan on 09/07/2025.
//
import SwiftUI

struct ChallengeProgressView: View {
    let progress: Double
    let goal: Double

    private var percentage: Double {
        guard goal > 0 else { return 0.0 }
        return min(progress / goal, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Desafío Semanal").font(.headline)
                Spacer()
                Text("\(progress / 1000, specifier: "%.1f") / \(Int(goal / 1000)) km")
                    .font(.subheadline).foregroundColor(.secondary)
            }
            ProgressView(value: percentage)
                .tint(.green)
        }
        .padding().background(.regularMaterial).cornerRadius(15).shadow(radius: 3, x: 0, y: 2)
    }
}
