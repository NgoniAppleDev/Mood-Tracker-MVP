//
//  MoodSelectionScreen.swift
//  Mood Tracker
//
//  Created by Ngoni Katsidzira  on 28/1/2025.
//

import SwiftUI
import SwiftData

struct MoodSelectionScreen: View {
    var viewModel: SavedMoodViewModel
    
    var body: some View {
        ZStack {
            Color(viewModel.selectedMood.color.opacity(0.2))
                .ignoresSafeArea()
            
            VStack {
                Text("How are you feeling today?")
                    .font(.largeTitle.weight(.bold))
                Spacer()
                
                BlobView(colour: viewModel.selectedMood.color)
                
                Spacer()
                
                Text("\(viewModel.selectedMood.rawValue)")
                    .font(.title)
                
                Spacer()
                
                MoodSlider(viewModel: viewModel)
                
                Spacer()
                
                Button {
                    viewModel.save(mood: viewModel.selectedMood, date: Date())
                } label: {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.selectedMood.color)
                        .foregroundColor(.white)
                        .clipShape(.capsule)
                }
            }
            .padding(overallScreenPadding)
        }
    }
}

let overallScreenPadding: CGFloat = 40

struct MoodSlider: View {
    var viewModel: SavedMoodViewModel
    private let size: CGFloat = 40
    @State private var xValue: CGFloat = 0
    private let steps = 5
    
    var body: some View {
        GeometryReader { proxy in
            let stepWidth = (proxy.size.width - size) / CGFloat(steps - 1)
            
            VStack(spacing: 10) {
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(width: proxy.size.width, height: size)
                        .opacity(0.2)
                        .foregroundStyle(.gray)
                    Circle()
                        .foregroundColor(.white)
                        .shadow(radius: 1)
                        .frame(width: size, height: size)
                        .offset(x: xValue)
                        .gesture(DragGesture().onChanged { value in
                            viewModel.updateMoodValue(slideXValue: value.location.x, stepWidth: stepWidth, size: size, proxy: proxy)
                            self.xValue = CGFloat(viewModel.moodValue) * stepWidth
                        })
                }
                HStack {
                    Text("Very Unpleasant")
                    Spacer()
                    Text("Very Pleasant")
                }
                .font(.caption)
            }
            
        }
        .frame(height: size)
    }
}

struct BlobView: View {
    let colour: Color
    
    var body: some View {
        Circle()
            .foregroundStyle(colour)
            .frame(width: 200, height: 200)
    }
}

#Preview {
    MoodSelectionScreen(viewModel: SavedMoodViewModel())
}
