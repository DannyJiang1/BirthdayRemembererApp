//
//  AddBirthdayViewModel.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/5/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AddBirthdayViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var month: Int = Calendar.current.component(.month, from: Date())
    @Published var day: Int = Calendar.current.component(.day, from: Date())
    @Published var notes: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    private let db = Firestore.firestore()
    
    func addBirthday() {
        guard validate() else {
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not authenticated"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        let birthdayItem = BirthdayItem(
            name: name.trimmingCharacters(in: .whitespaces),
            month: month,
            day: day,
            userId: userId,
            notes: notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : notes.trimmingCharacters(in: .whitespaces)
        )
        
        do {
            try db.collection("birthdays").document(birthdayItem.id).setData(from: birthdayItem)
            
            // Reset form
            name = ""
            month = Calendar.current.component(.month, from: Date())
            day = Calendar.current.component(.day, from: Date())
            notes = ""
            isLoading = false
        } catch {
            errorMessage = "Failed to add birthday: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func validate() -> Bool {
        errorMessage = ""
        
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a name"
            return false
        }
        
        guard month >= 1 && month <= 12 else {
            errorMessage = "Please select a valid month"
            return false
        }
        
        guard day >= 1 && day <= 31 else {
            errorMessage = "Please select a valid day"
            return false
        }
        
        // Validate that the day exists in the selected month
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: 2024, month: month, day: day)
        guard calendar.date(from: dateComponents) != nil else {
            errorMessage = "Invalid date (e.g., February 30th doesn't exist)"
            return false
        }
        
        return true
    }
}
