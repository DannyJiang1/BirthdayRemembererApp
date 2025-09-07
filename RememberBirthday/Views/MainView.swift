//
//  ContentView.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/4/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var mainViewModel = MainViewModel()
    @StateObject private var birthdayViewModel = BirthdayItemViewModel()
    @StateObject private var upcomingViewModel: UpcomingBirthdayViewModel
    
    init() {
        let birthdayVM = BirthdayItemViewModel()
        _birthdayViewModel = StateObject(wrappedValue: birthdayVM)
        _upcomingViewModel = StateObject(wrappedValue: UpcomingBirthdayViewModel(birthdayViewModel: birthdayVM))
    }

    var body: some View {
        Group {
            if mainViewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if mainViewModel.isLoggedIn {
                HomeView()
                    .environmentObject(mainViewModel)
                    .environmentObject(birthdayViewModel)
                    .environmentObject(upcomingViewModel)
            } else {
                LoginView()
            }
        }
        .onAppear {
            upcomingViewModel.scheduleBirthdayNotifications()
        }
        .onChange(of: mainViewModel.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                print("🔧 User logged in, fetching birthdays...")
                // Add a small delay to ensure authentication is fully complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    birthdayViewModel.fetchBirthdays()
                }
            } else {
                print("🔧 User logged out, clearing birthdays...")
                birthdayViewModel.clearBirthdays()
            }
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var birthdayViewModel: BirthdayItemViewModel
    @EnvironmentObject var upcomingViewModel: UpcomingBirthdayViewModel
    @State private var showingAddBirthday = false
    @State private var showingUpcomingView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HeaderView(
                    title: "Birthday Tracker",
                    subtitle: "Welcome back, \(mainViewModel.currentUser?.name ?? "User")!",
                    angle: 15,
                    backgroundColor: .purple
                )
                
                // Upcoming Birthdays List
                if upcomingViewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Loading birthdays...")
                            .font(.headline)
                        Spacer()
                    }
                } else if upcomingViewModel.upcomingBirthdays.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
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
                            title: "Add Your First Birthday",
                            backgroundColor: .blue
                        ) {
                            showingAddBirthday = true
                        }
                        .padding(.top, 20)
                        .frame(width: 300, height: 50)
                        Spacer()
                    }
                } else {
                    VStack(spacing: 0) {
                        List {
                            // Today's Birthdays Section
                            if !upcomingViewModel.todaysBirthdays.isEmpty {
                                Section {
                                    ForEach(upcomingViewModel.todaysBirthdays) { birthday in
                                        BirthdayItemView(birthday: birthday)
                                            .environmentObject(birthdayViewModel)
                                    }
                                } header: {
                                    Text("Today's Birthdays 🎉")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            // Upcoming Birthdays Section
                            Section {
                                ForEach(upcomingViewModel.upcomingBirthdays) { birthday in
                                    BirthdayItemView(birthday: birthday)
                                        .environmentObject(birthdayViewModel)
                                }
                            } header: {
                                Text("Upcoming Birthdays")
                                    .font(.headline)
                            }
                        }
                        .listStyle(PlainListStyle())
                        
                        // View All Button - Always visible
                        Button(action: {
                            showingUpcomingView = true
                        }) {
                            HStack {
                                Spacer()
                                Text("View All Birthdays")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.purple)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.purple)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        
                        // Blue Add Button at bottom - Much shorter
                        Button(action: {
                            showingAddBirthday = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.subheadline)
                                Text("Add New Birthday")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .background(Color.blue)
                            .cornerRadius(6)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    }
                }
            }
            .navigationTitle("Birthdays")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Logout") {
                        mainViewModel.logout()
                    }
                }
            }
            .sheet(isPresented: $showingAddBirthday) {
                AddBirthdayView()
                    .environmentObject(birthdayViewModel)
            }
            .sheet(isPresented: $showingUpcomingView) {
                NavigationView {
                    UpcomingBirthdayView()
                        .environmentObject(upcomingViewModel)
                        .environmentObject(birthdayViewModel)
                }
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: Item.self, inMemory: true)
}

