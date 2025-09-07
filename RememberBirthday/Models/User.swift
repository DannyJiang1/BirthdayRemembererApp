//
//  User.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/5/25.
//

import Foundation
import FirebaseAuth

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let createdAt: Date
    
    init(id: String, name: String, email: String, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.createdAt = createdAt
    }
    
    init(from firebaseUser: FirebaseAuth.User, name: String) {
        self.id = firebaseUser.uid
        self.name = name
        self.email = firebaseUser.email ?? ""
        self.createdAt = Date()
    }
}
