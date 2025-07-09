//
//  AuthViewModel.swift
//  TheMarathon
//
//  Created by Juan Augusto Roldan on 09/07/2025.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var firebaseUser: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var errorMessage = ""
    @Published var isLoading = false

    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    private var userListener: ListenerRegistration?

    init() {
        authStateHandle = auth.addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            self.firebaseUser = user
            
            if let user = user {
                self.listenToUserData(userId: user.uid)
            } else {
                self.currentUser = nil
                self.userListener?.remove()
            }
        }
    }

    deinit {
        if let handle = authStateHandle {
            auth.removeStateDidChangeListener(handle)
        }
        userListener?.remove()
    }
    
    func listenToUserData(userId: String) {
        userListener?.remove()
        userListener = db.collection("users").document(userId).addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self, let document = documentSnapshot, let data = document.data() else { return }
            self.currentUser = User(id: document.documentID, dictionary: data)
        }
    }
    
    func updateWeeklyChallenge(goalInKm: Double) {
        guard let userId = firebaseUser?.uid else { return }
        let goalInMeters = goalInKm * 1000
        db.collection("users").document(userId).updateData(["weeklyChallengeGoal": goalInMeters])
    }

    func login(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        auth.signIn(withEmail: email, password: password) { [weak self] (_, error) in
            defer { self?.isLoading = false }
            if let error = error {
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    func signUp(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = ""
        auth.createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let self = self, let user = authResult?.user else {
                self?.isLoading = false
                completion(false)
                return
            }
            let userData: [String: Any] = ["name": name, "email": email, "createdAt": Timestamp()]
            self.db.collection("users").document(user.uid).setData(userData) { error in
                defer { self.isLoading = false }
                if error == nil {
                    completion(true)
                } else {
                    self.errorMessage = error?.localizedDescription ?? "Error desconocido"
                    completion(false)
                }
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
