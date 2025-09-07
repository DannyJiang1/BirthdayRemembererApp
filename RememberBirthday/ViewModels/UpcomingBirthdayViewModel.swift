//
//  UpcomingBirthdayViewModel.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/5/25.
//

import Foundation
import UserNotifications
import Combine

class UpcomingBirthdayViewModel: ObservableObject {
    @Published var upcomingBirthdays: [BirthdayItem] = []
    @Published var todaysBirthdays: [BirthdayItem] = []
    @Published var isLoading: Bool = false
    
    private let birthdayViewModel: BirthdayItemViewModel
    
    init(birthdayViewModel: BirthdayItemViewModel) {
        self.birthdayViewModel = birthdayViewModel
        
        // Observe changes in the birthday list
        birthdayViewModel.$birthdays
            .map { birthdays in
                print("🔄 UpcomingBirthdayViewModel: Received \(birthdays.count) birthdays")
                for (index, birthday) in birthdays.enumerated() {
                    print("🔄 Birthday \(index + 1): \(birthday.name) - Days until: \(birthday.daysUntilBirthday)")
                }
                
                let upcoming = birthdays.filter { $0.daysUntilBirthday <= 30 }
                    .sorted { $0.daysUntilBirthday < $1.daysUntilBirthday }
                print("🔄 UpcomingBirthdayViewModel: Processing \(birthdays.count) birthdays, \(upcoming.count) upcoming")
                for birthday in upcoming {
                    print("🔄 Upcoming: \(birthday.name) - \(birthday.daysUntilBirthday) days")
                }
                return upcoming
            }
            .assign(to: &$upcomingBirthdays)
        
        birthdayViewModel.$birthdays
            .map { birthdays in
                let today = birthdays.filter { $0.daysUntilBirthday == 0 }
                print("🔄 UpcomingBirthdayViewModel: \(today.count) birthdays today")
                return today
            }
            .assign(to: &$todaysBirthdays)
        
        birthdayViewModel.$isLoading
            .assign(to: &$isLoading)
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleBirthdayNotifications() {
        requestNotificationPermission()
        
        // Cancel existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Schedule notifications for upcoming birthdays
        for birthday in upcomingBirthdays.prefix(10) { // Limit to 10 notifications
            scheduleNotification(for: birthday)
        }
    }
    
    private func scheduleNotification(for birthday: BirthdayItem) {
        let content = UNMutableNotificationContent()
        content.title = "Birthday Reminder"
        content.body = "It's \(birthday.name)'s birthday today! 🎉"
        content.sound = .default
        content.badge = 1
        
        let calendar = Calendar.current
        let nextBirthday = birthday.nextBirthday
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextBirthday)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(
            identifier: "birthday_\(birthday.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
