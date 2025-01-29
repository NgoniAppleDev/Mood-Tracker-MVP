//
//  MoodHistoryView.swift
//  Mood Tracker
//
//  Created by Ngoni Katsidzira  on 28/1/2025.
//

import SwiftUI
import SwiftData

struct TappedDate: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var mood: Mood
}

struct MoodHistoryView: View {
    var viewModel: SavedMoodViewModel
    
    @State private var tappedDate: TappedDate?
    @State private var message: String = ""
    @State private var showMessage: Bool = false
    
    var body: some View {
        VStack {
            HeaderView(viewModel: viewModel)
            CalendarView(tappedDate: $tappedDate, showMessage: $showMessage, message: $message, viewModel: viewModel)
        }
        .alert(message, isPresented: $showMessage) {}
        .sheet(item: $tappedDate) { NonOptionalTappedDate in
            MoodPickerSheet(tappedDate: $tappedDate) { mood in
                viewModel.save(mood: mood, date: NonOptionalTappedDate.date)
                tappedDate = nil
            } dismiss: {
                tappedDate = nil
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .padding(20)
    }
}

struct MoodPickerSheet: View {
    @Binding var tappedDate: TappedDate?
    let onSave: (Mood) -> Void
    let dismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Mood")
                .font(.title.weight(.bold))
                .padding()
            
            VStack {
                Divider()
                
                HStack {
                    Text("Current Mood:")
                    Spacer()
                    HStack {
                        Circle()
                            .fill(tappedDate?.mood.color ?? .mint)
                            .frame(width: 20, height: 20)
                        Text(tappedDate?.mood.rawValue.capitalized ?? "_")
                    }
                }
                
                Divider()
            }
            .padding()
            
            ForEach(Mood.allCases, id: \.self) { mood in
                Button(action: {
                    onSave(mood)
                    dismiss()
                }) {
                    HStack {
                        Circle()
                            .fill(mood.color)
                            .frame(width: 20, height: 20)
                        Text(mood.rawValue.capitalized)
                            .padding()
                    }
                }
                .padding()
            }
        }
    }
}


struct HeaderView: View {
    var viewModel: SavedMoodViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.selectedDate =
                Calendar.current.date(byAdding: .month, value: -1, to: viewModel.selectedDate)!
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            Text(viewModel.selectedDate, format: .dateTime.month(.wide).year())
                .font(.largeTitle)
            
            Spacer()
            
            Button {
                viewModel.selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.selectedDate)!
            } label: {
                Image(systemName: "chevron.right")
            }
            
        }
        .font(.largeTitle)
        .tint(.black)
    }
}

struct CalendarView: View {
    @Binding var tappedDate: TappedDate?
    @Binding var showMessage: Bool
    @Binding var message: String
    
    var viewModel: SavedMoodViewModel
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var body: some View {
        LazyVGrid(columns: columns) {
            DaysOfWeekView()
            DaysOfMonthView(tappedDate: $tappedDate, showMessage: $showMessage, message: $message, viewModel: viewModel)
        }
    }
    
    struct DaysOfWeekView: View {
        let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        var body: some View {
            ForEach(daysOfWeek, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(.caption)
            }
        }
    }
    
    struct DaysOfMonthView: View {
        @Binding var tappedDate: TappedDate?
        @Binding var showMessage: Bool
        @Binding var message: String
        var viewModel: SavedMoodViewModel
        
        var body: some View {
            ForEach(viewModel.monthDays, id: \.self) { dayOfMonth in
                let moodForDay = viewModel.moodForDay(date: dayOfMonth)
                
                ZStack {
                    Circle()
                        .fill(moodForDay.color)
                        .frame(width: 40, height: 40)
                    Text(Calendar.current.component(.day, from: dayOfMonth).description)
                        .foregroundColor(.black)
                }
                .onTapGesture {
                    let today = Date().normalisedDate
                    let tapDate = dayOfMonth
                    if  tapDate <= today {
                        tappedDate = TappedDate(date: dayOfMonth, mood: moodForDay)
                    } else {
                        message = "Sorry\nYou can't set mood for future dates."
                        showMessage = true
                    }
                }
            }
        }
    }
}

#Preview {
    MoodHistoryView(viewModel: SavedMoodViewModel())
}
