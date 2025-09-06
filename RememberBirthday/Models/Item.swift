//
//  Item.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/5/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date = .now) {
        self.timestamp = timestamp
    }
}
