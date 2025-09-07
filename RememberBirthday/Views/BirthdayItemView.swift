//
//  BirthdayItemView.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/5/25.
//

import SwiftUI

struct BirthdayItemView: View {
    let birthday: BirthdayItem
    @EnvironmentObject var birthdayViewModel: BirthdayItemViewModel
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    private var daysText: String {
        if birthday.daysUntilBirthday == 0 {
            return "Today! 🎉"
        } else if birthday.daysUntilBirthday == 1 {
            return "Tomorrow"
        } else {
            return "In \(birthday.daysUntilBirthday) days"
        }
    }
    
    private var ageText: String {
        if birthday.daysUntilBirthday == 0 {
            return "Birthday today! 🎉"
        } else {
            return birthday.birthdayString
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(birthday.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(ageText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let notes = birthday.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(daysText)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(birthday.daysUntilBirthday == 0 ? .red : .blue)
                    
                    Text(formatBirthday(birthday.nextBirthday))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if birthday.daysUntilBirthday == 0 {
                HStack {
                    Image(systemName: "gift.fill")
                        .foregroundColor(.red)
                    Text("Happy Birthday!")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(birthday.daysUntilBirthday == 0 ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(birthday.daysUntilBirthday == 0 ? Color.red.opacity(0.3) : Color.blue.opacity(0.3), lineWidth: 1)
        )
        .contextMenu {
            Button("Edit") {
                showingEditSheet = true
            }
            
            Button("Delete", role: .destructive) {
                showingDeleteAlert = true
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditBirthdayView(birthday: birthday)
                .environmentObject(birthdayViewModel)
        }
        .alert("Delete Birthday", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                birthdayViewModel.deleteBirthday(birthday)
            }
        } message: {
            Text("Are you sure you want to delete \(birthday.name)'s birthday?")
        }
    }
    
    private func formatBirthday(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct EditBirthdayView: View {
    @State private var name: String
    @State private var month: Int
    @State private var day: Int
    @State private var notes: String
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    let originalBirthday: BirthdayItem
    @EnvironmentObject var birthdayViewModel: BirthdayItemViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(birthday: BirthdayItem) {
        self.originalBirthday = birthday
        self._name = State(initialValue: birthday.name)
        self._month = State(initialValue: birthday.month)
        self._day = State(initialValue: birthday.day)
        self._notes = State(initialValue: birthday.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(
                    title: "Edit Birthday",
                    subtitle: "Update birthday information",
                    angle: -15,
                    backgroundColor: .orange
                )
                .offset(y: -50)
                
                Form {
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    Section(header: Text("Birthday Information")) {
                        TextField("Name", text: $name)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                        
                        HStack {
                            Picker("Month", selection: $month) {
                                ForEach(1...12, id: \.self) { month in
                                    Text(DateFormatter().monthSymbols[month - 1]).tag(month)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            Picker("Day", selection: $day) {
                                ForEach(1...31, id: \.self) { day in
                                    Text("\(day)").tag(day)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        TextField("Notes (Optional)", text: $notes, axis: .vertical)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    
                    Section {
                        ButtonView(
                            title: isLoading ? "Updating..." : "Update Birthday",
                            backgroundColor: .orange
                        ) {
                            updateBirthday()
                        }
                        .disabled(isLoading)
                    }
                }
                .offset(y: -20)
                
                Spacer()
            }
            .navigationTitle("Edit Birthday")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func updateBirthday() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a name"
            return
        }
        
        guard month >= 1 && month <= 12 else {
            errorMessage = "Please select a valid month"
            return
        }
        
        guard day >= 1 && day <= 31 else {
            errorMessage = "Please select a valid day"
            return
        }
        
        // Validate that the day exists in the selected month
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: 2024, month: month, day: day)
        guard calendar.date(from: dateComponents) != nil else {
            errorMessage = "Invalid date (e.g., February 30th doesn't exist)"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        let updatedBirthday = BirthdayItem(
            id: originalBirthday.id,
            name: name.trimmingCharacters(in: .whitespaces),
            month: month,
            day: day,
            userId: originalBirthday.userId,
            notes: notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : notes.trimmingCharacters(in: .whitespaces),
            createdAt: originalBirthday.createdAt
        )
        
        birthdayViewModel.updateBirthday(updatedBirthday)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isLoading = false
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    BirthdayItemView(birthday: BirthdayItem(
        name: "John Doe",
        month: 12,
        day: 25,
        userId: "test-user-id",
        notes: "Best friend from college"
    ))
    .environmentObject(BirthdayItemViewModel())
}
