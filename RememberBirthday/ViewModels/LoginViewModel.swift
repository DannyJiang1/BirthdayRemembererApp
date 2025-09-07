//
//  LoginViewModel.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/5/25.
//

import FirebaseAuth
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isLoggedIn: Bool = false
    
    init() {
        // Check if user is already logged in
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        }
    }
    
    func login() {
        guard validate() else {
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Failed to log in."
                    return
                }
                
                if result?.user != nil {
                    self?.isLoggedIn = true
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            email = ""
            password = ""
            errorMessage = ""
        } catch {
            errorMessage = "Failed to logout: \(error.localizedDescription)"
        }
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Invalid email format"
            return false
        }
        
        return true
    }
}
