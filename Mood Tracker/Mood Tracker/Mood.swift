//
//  Mood.swift
//  Mood Tracker
//
//  Created by Ngoni Katsidzira  on 28/1/2025.
//

import SwiftUI

enum Mood: String, CaseIterable, Codable {
    case veryUnpleasant = "Very Unpleasant"
    case unpleasant = "Unpleasant"
    case neutral = "Neutral"
    case pleasant = "Pleasant"
    case veryPleasant = "Very Pleasant"
    
    var color: Color {
        switch self {
        case .veryUnpleasant:
                .red
        case .unpleasant:
                .orange
        case .neutral:
                .yellow
        case .pleasant:
                .green
        case .veryPleasant:
                .blue
        }
    }
}
