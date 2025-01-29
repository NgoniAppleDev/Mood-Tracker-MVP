//
//  MainView.swift
//  Mood Tracker
//
//  Created by Ngoni Katsidzira  on 28/1/2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @State var viewModel: SavedMoodViewModel = .init()
    
    var body: some View {
        TabView {
            MoodSelectionScreen(viewModel: viewModel)
                .tabItem {
                    Label("Mood Selection", systemImage: "square.and.pencil")
                }
            MoodHistoryView(viewModel: viewModel)
                .tabItem {
                    Label("Mood History", systemImage: "list.dash")
                }
        }
        .tint(.primary)
        .onAppear {
            viewModel = SavedMoodViewModel(modelContext: modelContext)
        }
    }
}

#Preview {
    MainView()
}
