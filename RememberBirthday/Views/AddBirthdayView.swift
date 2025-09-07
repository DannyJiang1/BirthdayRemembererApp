//
//  AddBirthdayView.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/4/25.
//

import SwiftUI

struct AddBirthdayView: View {
    @StateObject private var viewModel = AddBirthdayViewModel()
    @EnvironmentObject var birthdayViewModel: BirthdayItemViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(
                    title: "Add Birthday",
                    subtitle: "Never forget a special day",
                    angle: 15,
                    backgroundColor: .purple
                )
                .offset(y: -50)
                
                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    Section(header: Text("Birthday Information")) {
                        TextField("Name", text: $viewModel.name)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                        
                        HStack {
                            Picker("Month", selection: $viewModel.month) {
                                ForEach(1...12, id: \.self) { month in
                                    Text(DateFormatter().monthSymbols[month - 1]).tag(month)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            Picker("Day", selection: $viewModel.day) {
                                ForEach(1...31, id: \.self) { day in
                                    Text("\(day)").tag(day)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        TextField("Notes (Optional)", text: $viewModel.notes, axis: .vertical)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    
                    Section {
                        ButtonView(
                            title: viewModel.isLoading ? "Adding..." : "Add Birthday",
                            backgroundColor: .blue
                        ) {
                            addBirthday()
                        }
                        .disabled(viewModel.isLoading)
                    }
                }
                .offset(y: -20)
                
                Spacer()
            }
            .navigationTitle("Add Birthday")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onChange(of: viewModel.isLoading) { isLoading in
            if !isLoading && viewModel.errorMessage.isEmpty {
                // Birthday added successfully, dismiss the view
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func addBirthday() {
        guard viewModel.validate() else {
            return
        }
        
        viewModel.isLoading = true
        
                birthdayViewModel.addBirthday(
                    name: viewModel.name.trimmingCharacters(in: .whitespaces),
                    month: viewModel.month,
                    day: viewModel.day,
                    notes: viewModel.notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : viewModel.notes.trimmingCharacters(in: .whitespaces)
                )
        
        // Reset form
        viewModel.name = ""
        viewModel.month = Calendar.current.component(.month, from: Date())
        viewModel.day = Calendar.current.component(.day, from: Date())
        viewModel.notes = ""
        viewModel.isLoading = false
        
        // Dismiss the view
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddBirthdayView()
        .environmentObject(BirthdayItemViewModel())
}
