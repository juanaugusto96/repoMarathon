//
//  RunView.swift
//  TheMarathon
//
//  Created by Juan Augusto Roldan on 09/07/2025.
//

import SwiftUI

struct RunView: View {
    @EnvironmentObject var runManager: RunManager
    @Binding var showRunView: Bool
    @State private var showResults = false // Nuevo estado para mostrar resultados

    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text(timeFormatter.string(from: runManager.elapsedTime) ?? "00:00:00")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(runManager.isPaused ? .orange : .primary)
            
            Text(String(format: "%.2f km", runManager.distance / 1000))
                .font(.system(size: 40, weight: .semibold, design: .rounded))

            Spacer()
            
            HStack(spacing: 40) {
                // Botón de Pausa / Reanudar
                Button {
                    runManager.isPaused ? runManager.resumeRunning() : runManager.pauseRunning()
                } label: {
                    Image(systemName: runManager.isPaused ? "play.fill" : "pause.fill")
                        .font(.largeTitle).padding().background(runManager.isPaused ? Color.green : Color.orange).clipShape(Circle())
                }
                
                // Botón de Detener
                Button {
                    runManager.stopRunning()
                    showResults = true // Mostramos la vista de resultados
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle).padding().background(Color.red).clipShape(Circle())
                }
            }
            .foregroundColor(.white)
            .padding(.bottom, 50)
        }
        .padding()
        .sheet(isPresented: $showResults, onDismiss: {
            // Cuando la hoja de resultados se cierre, cerramos también esta vista
            showRunView = false
        }) {
            ResultView() // Presentamos la vista de resultados
        }
    }
}
