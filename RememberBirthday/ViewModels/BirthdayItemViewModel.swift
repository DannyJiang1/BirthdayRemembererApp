//
//  BirthdayItemViewModel.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/5/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class BirthdayItemViewModel: ObservableObject {
    @Published var birthdays: [BirthdayItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        // Don't fetch immediately - wait for user to be authenticated
        print("🔧 BirthdayItemViewModel initialized")
    }
    
    deinit {
        listener?.remove()
    }
    
    func fetchBirthdays() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ No authenticated user found")
            errorMessage = "User not authenticated"
            return
        }
        
        print("🔍 Fetching birthdays for user: \(userId)")
        isLoading = true
        errorMessage = ""
        
        listener = db.collection("birthdays")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        print("❌ Firestore error: \(error.localizedDescription)")
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("📅 No documents found")
                        self?.birthdays = []
                        return
                    }
                    
                    print("📅 Found \(documents.count) documents in Firestore")
                    
                    // Debug: Print all raw documents
                    for (index, document) in documents.enumerated() {
                        print("📄 Document \(index + 1): \(document.documentID)")
                        print("📄 Data: \(document.data())")
                    }
                    
                    self?.birthdays = documents.compactMap { document in
                        do {
                            let birthday = try document.data(as: BirthdayItem.self)
                            print("📅 Parsed birthday: \(birthday.name) - \(birthday.birthdayString)")
                            return birthday
                        } catch {
                            print("❌ Error parsing birthday document: \(error)")
                            print("❌ Document data: \(document.data())")
                            return nil
                        }
                    }.sorted { $0.nextBirthday < $1.nextBirthday }
                    
                    print("📅 Final birthdays array count: \(self?.birthdays.count ?? 0)")
                    for (index, birthday) in (self?.birthdays ?? []).enumerated() {
                        print("📅 Birthday \(index + 1): \(birthday.name) - \(birthday.birthdayString)")
                    }
                    
                    print("📅 Successfully loaded \(self?.birthdays.count ?? 0) birthdays from Firestore")
                    print("📅 Upcoming birthdays: \(self?.upcomingBirthdays.count ?? 0)")
                    print("📅 Today's birthdays: \(self?.todaysBirthdays.count ?? 0)")
                }
            }
    }
    
    func addBirthday(name: String, month: Int, day: Int, notes: String? = nil) {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not authenticated"
            return
        }
        
        let birthdayItem = BirthdayItem(
            name: name,
            month: month,
            day: day,
            userId: userId,
            notes: notes
        )
        
        do {
            try db.collection("birthdays").document(birthdayItem.id).setData(from: birthdayItem)
            print("✅ Successfully added birthday: \(birthdayItem.name)")
        } catch {
            errorMessage = "Failed to add birthday: \(error.localizedDescription)"
            print("❌ Failed to add birthday: \(error.localizedDescription)")
        }
    }
    
    // Convenience method for backward compatibility
    func addBirthday(name: String, birthday: Date, notes: String? = nil) {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: birthday)
        let day = calendar.component(.day, from: birthday)
        addBirthday(name: name, month: month, day: day, notes: notes)
    }
    
    func updateBirthday(_ birthday: BirthdayItem) {
        do {
            try db.collection("birthdays").document(birthday.id).setData(from: birthday)
        } catch {
            errorMessage = "Failed to update birthday: \(error.localizedDescription)"
        }
    }
    
    func deleteBirthday(_ birthday: BirthdayItem) {
        db.collection("birthdays").document(birthday.id).delete { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to delete birthday: \(error.localizedDescription)"
                }
            }
        }
    }
    
    var upcomingBirthdays: [BirthdayItem] {
        birthdays.filter { $0.daysUntilBirthday <= 90 }
            .sorted { $0.daysUntilBirthday < $1.daysUntilBirthday }
    }
    
    var todaysBirthdays: [BirthdayItem] {
        birthdays.filter { $0.daysUntilBirthday == 0 }
    }
    
    func clearBirthdays() {
        print("🧹 Clearing birthdays")
        listener?.remove()
        listener = nil
        birthdays = []
        isLoading = false
        errorMessage = ""
    }
}
