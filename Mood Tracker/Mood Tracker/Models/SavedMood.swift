//
//  SavedMood.swift
//  Mood Tracker
//
//  Created by Ngoni Katsidzira  on 28/1/2025.
//

import Foundation
import SwiftData

@Model
class SavedMood {
    var date: Date
    var mood: Mood
    
    init(date: Date, mood: Mood) {
        self.date = date
        self.mood = mood
    }
}
