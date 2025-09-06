//
//  ContentView.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/4/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        LoginView()
    }
}

#Preview {
    MainView()
        .modelContainer(for: Item.self, inMemory: true)
}
