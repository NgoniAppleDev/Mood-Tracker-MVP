//
//  ContentView.swift
//  Mood Tracker
//
//  Created by Ngoni Katsidzira  on 28/1/2025.
//

import SwiftUI

enum Mood: String {
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

struct ContentView: View {
    @State private var moodValue: Double = 0
    private var selectedMood: Mood {
        switch moodValue {
        case 0: .veryUnpleasant
        case 1: .unpleasant
        case 2: .neutral
        case 3: .pleasant
        case 4: .veryPleasant
        default: .neutral
        }
    }
    
    var body: some View {
        ZStack {
            Color(selectedMood.color.opacity(0.2))
                .ignoresSafeArea()
            
            VStack {
                Text("How are you feeling today?")
                    .font(.largeTitle.weight(.bold))
                Spacer()
                
                BlobView(colour: selectedMood.color)
                
                Spacer()
                
                Text("\(selectedMood.rawValue)")
                    .font(.title)
                
                Spacer()
                
                //            Slider(value: $moodValue, in: 0...4, step: 1)
                MoodSlider(moodValue: $moodValue)
                Spacer()
                
                Button {
                    // TODO: Save the mood.
                } label: {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedMood.color)
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
    private let size: CGFloat = 40
    @State private var xValue: CGFloat = 0
    @Binding var moodValue: Double
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
                            let minX: CGFloat = 0
                            let maxX: CGFloat = proxy.size.width - size
                            let clampedXValue = min(max(minX, value.location.x), maxX)
                            
                            let step = round(clampedXValue / stepWidth)
                            self.xValue = step * stepWidth
                            self.moodValue = step
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
    ContentView()
}
