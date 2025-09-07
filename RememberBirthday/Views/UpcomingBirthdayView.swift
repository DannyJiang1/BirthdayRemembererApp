//
//  UpcomingBirthdayView.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/5/25.
//

import SwiftUI

struct UpcomingBirthdayView: View {
    @EnvironmentObject var upcomingViewModel: UpcomingBirthdayViewModel
    @EnvironmentObject var birthdayViewModel: BirthdayItemViewModel
    @State private var showingAddBirthday = false
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(
                    title: "Upcoming Birthdays",
                    subtitle: "Never miss a special day",
                    angle: 15,
                    backgroundColor: .green
                )
                .offset(y: -50)
                
                if upcomingViewModel.isLoading {
                    ProgressView("Loading birthdays...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if upcomingViewModel.upcomingBirthdays.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "gift")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No upcoming birthdays")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text("Add some birthdays to get started!")
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        ButtonView(
                            title: "Add First Birthday",
                            backgroundColor: .blue
                        ) {
                            showingAddBirthday = true
                        }
                        .padding(.top, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(upcomingViewModel.upcomingBirthdays) { birthday in
                            BirthdayItemView(birthday: birthday)
                                .environmentObject(birthdayViewModel)
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Upcoming Birthdays")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddBirthday = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddBirthday) {
                AddBirthdayView()
                    .environmentObject(birthdayViewModel)
            }
        }
    }
}

#Preview {
    UpcomingBirthdayView()
        .environmentObject(UpcomingBirthdayViewModel(birthdayViewModel: BirthdayItemViewModel()))
        .environmentObject(BirthdayItemViewModel())
}
