//
//  RegisterViewModel.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/6/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    init() {
        
    }
    
    func register() {
        guard validate() else {
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let user = result?.user else {
                    self?.errorMessage = "Failed to create user"
                    return
                }
                
                // Save user data to Firestore
                self?.saveUserData(user: user)
            }
        }
    }
    
    private func saveUserData(user: FirebaseAuth.User) {
        let db = Firestore.firestore()
        let userData = User(from: user, name: name)
        
        do {
            try db.collection("users").document(user.uid).setData(from: userData)
        } catch {
            errorMessage = "Failed to save user data: \(error.localizedDescription)"
        }
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Invalid email format"
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        
        return true
    }
}
