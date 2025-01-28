//
//  MoodSelectionScreenViewModel.swift
//  Mood Tracker
//
//  Created by Ngoni Katsidzira  on 28/1/2025.
//

import Foundation
import SwiftUI
import Observation

@Observable
class MoodSelectionScreenViewModel {
    var moodValue: Double = 0
    var selectedMood: Mood {
        let index = Int(round(moodValue))
        return Mood.allCases[index]
    }
    
    func updateMoodValue(slideXValue: CGFloat, stepWidth: CGFloat, size: CGFloat, proxy: GeometryProxy) {
        let minX: CGFloat = 0
        let maxX: CGFloat = proxy.size.width - size
        let clampedXValue = min(max(minX, slideXValue), maxX)
        
        let step = round(clampedXValue / stepWidth)
        self.moodValue = step
    }
}
