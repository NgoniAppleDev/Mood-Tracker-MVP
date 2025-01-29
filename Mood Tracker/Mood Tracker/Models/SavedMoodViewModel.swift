//
//  SavedMoodViewModel.swift
//  Mood Tracker
//
//  Created by Ngoni Katsidzira  on 28/1/2025.
//

import Foundation
import SwiftUI
import SwiftData
import Observation

@Observable
class SavedMoodViewModel {
    var selectedDate = Date() {
        didSet {
            updateMonthDay()
        }
    }
    var monthDays = [Date]()
    private var savedMoods: [Date: Mood] = [:]
    private var modelContext: ModelContext?
    
    var moodValue: Double = 0
    var selectedMood: Mood {
        let index = Int(round(moodValue))
        return Mood.allCases[index]
    }
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        fetch()
        updateMonthDay()
    }
    
    private func updateMonthDay() {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        
        monthDays = range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    func moodForDay(date: Date) -> Mood {
        return savedMoods[date] ?? .unknown
    }
    
    func updateMoodValue(slideXValue: CGFloat, stepWidth: CGFloat, size: CGFloat, proxy: GeometryProxy) {
        let minX: CGFloat = 0
        let maxX: CGFloat = proxy.size.width - size
        let clampedXValue = min(max(minX, slideXValue), maxX)
        
        let step = round(clampedXValue / stepWidth)
        self.moodValue = step
    }
    
    // Save mood to Swift Data.
    func save(mood: Mood, date: Date) {
        let normalisedDate = date.normalisedDate
        if let existingMood = try? modelContext?.fetch(FetchDescriptor<SavedMood>()).first(where: { Calendar.current.isDate($0.date, inSameDayAs: normalisedDate) }) {
            existingMood.mood = mood
        } else {
            let savedMood = SavedMood(date: normalisedDate, mood: mood)
            modelContext?.insert(savedMood)
        }
        
        savedMoods[normalisedDate] = mood
    }
    
    // Fetch mood from Swift Data.
    func fetch() {
        do {
            if let fetchedMoods = try modelContext?.fetch(FetchDescriptor<SavedMood>()) {
                self.savedMoods = Dictionary(uniqueKeysWithValues: fetchedMoods.map { ($0.date, $0.mood) })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension Date {
    var normalisedDate: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
