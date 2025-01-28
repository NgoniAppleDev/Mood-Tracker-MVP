//
//  Mood_TrackerApp.swift
//  Mood Tracker
//
//  Created by Ngoni Katsidzira  on 28/1/2025.
//

import SwiftUI
import SwiftData

@main
struct Mood_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MoodSelectionScreen()
        }
        .modelContainer(for: SaveMood.self)
    }
}
