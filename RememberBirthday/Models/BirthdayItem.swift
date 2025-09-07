//
//  BirthdayItem.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/5/25.
//

import Foundation
import FirebaseFirestore

struct BirthdayItem: Identifiable, Codable {
    let id: String
    let name: String
    let month: Int  // 1-12
    let day: Int    // 1-31
    let userId: String
    let createdAt: Date
    let notes: String?
    
    init(id: String = UUID().uuidString, name: String, month: Int, day: Int, userId: String, notes: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.month = month
        self.day = day
        self.userId = userId
        self.notes = notes
        self.createdAt = createdAt
    }
    
    // Convenience initializer for backward compatibility
    init(id: String = UUID().uuidString, name: String, birthday: Date, userId: String, notes: String? = nil, createdAt: Date = Date()) {
        let calendar = Calendar.current
        self.id = id
        self.name = name
        self.month = calendar.component(.month, from: birthday)
        self.day = calendar.component(.day, from: birthday)
        self.userId = userId
        self.notes = notes
        self.createdAt = createdAt
    }
    
    var age: Int {
        // For recurring birthdays, we can't calculate age without a birth year
        // Return 0 or handle this differently based on your needs
        return 0
    }
    
    var nextBirthday: Date {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        
        // Create this year's birthday
        var thisYearBirthday = calendar.date(from: DateComponents(
            year: currentYear,
            month: month,
            day: day
        ))!
        
        // If this year's birthday has passed (not including today), use next year's
        if thisYearBirthday < calendar.startOfDay(for: now) {
            thisYearBirthday = calendar.date(from: DateComponents(
                year: currentYear + 1,
                month: month,
                day: day
            ))!
        }
        
        return thisYearBirthday
    }
    
    var daysUntilBirthday: Int {
        let calendar = Calendar.current
        let now = Date()
        let today = calendar.startOfDay(for: now)
        let birthdayThisYear = calendar.date(from: DateComponents(
            year: calendar.component(.year, from: now),
            month: month,
            day: day
        ))!
        
        let days = calendar.dateComponents([.day], from: today, to: nextBirthday).day ?? 0
        return days
    }
    
    // Helper to get a formatted birthday string
    var birthdayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: nextBirthday)
    }
}
