//
//  HomeView.swift
//  TheMarathon
//
//  Created by Juan Augusto Roldan on 09/07/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var runManager: RunManager
    @EnvironmentObject var runVM: RunViewModel

    @State private var showingCountdown = false
    @State private var showingHistory = false
    @State private var showingChallengeSelection = false
    @State private var showRunView = false

    var body: some View {
        ZStack {
            MapViewRepresentable(
                region: $runManager.region,
                showsUserLocation: true,
                userTrackingMode: .follow
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    Button { showingHistory = true } label: {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.title2).padding().background(.regularMaterial).clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button { showingChallengeSelection = true } label: {
                        Image(systemName: "target")
                            .font(.title2).padding().background(.regularMaterial).clipShape(Circle())
                    }
                }
                .padding(.horizontal)

                if let goal = authVM.currentUser?.weeklyChallengeGoal, goal > 0 {
                    ChallengeProgressView(
                        progress: runVM.weeklyProgressInMeters,
                        goal: goal
                    )
                    .padding(.horizontal)
                }
                
                Spacer()

                Button {
                    if runManager.authorizationStatus == .authorizedWhenInUse || runManager.authorizationStatus == .authorizedAlways {
                        showingCountdown = true
                    } else {
                        runManager.checkAndRequestLocationPermission()
                    }
                } label: {
                    Text("Iniciar Carrera")
                        .font(.title2.bold()).padding().frame(maxWidth: .infinity)
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10).shadow(radius: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showingCountdown) { CountDownView() }
        .sheet(isPresented: $showingHistory) { HistoryView() }
        .sheet(isPresented: $showingChallengeSelection) { ChallengeSelectionView() }
        .fullScreenCover(isPresented: $showRunView) { RunView(showRunView: $showRunView) }
        .task {
            runManager.checkAndRequestLocationPermission()
            if let userId = authVM.firebaseUser?.uid {
                runVM.fetchRuns(userId: userId)
            }
        }
        .onChange(of: runManager.isRunning) { _, isNowRunning in
            if isNowRunning {
                showRunView = true
            }
        }
    }
}
