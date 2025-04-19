//
//  TimerView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-28.
//

import SwiftUI

struct TimerView: View {
    @State private var isRunning = false
    @State private var elapsedTime = 0.0
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // Available countdown durations in seconds
    private let countdownDurations = [60.0, 120.0, 180.0]
    @State private var selectedDurationIndex = 0

    var body: some View {
        VStack {
            Picker("Select Duration", selection: $selectedDurationIndex) {
                ForEach(Array(countdownDurations.enumerated()), id: \.offset) { index, duration in
                    Text("\(Int(duration / 60)) min")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            HStack {
                Text(String(format: "%.1f seconds", countdownDurations[selectedDurationIndex] - elapsedTime))
                    .font(.headline)
                    .padding()

                Button(action: {
                    isRunning.toggle()
                }) {
                    Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                }
                .padding()
            }
        }
        .onReceive(timer) { _ in
            if isRunning && elapsedTime < countdownDurations[selectedDurationIndex] {
                elapsedTime += 1.0
            } else if elapsedTime >= countdownDurations[selectedDurationIndex] {
                // Timer reached the selected duration, stop the timer
                isRunning = false
            }
        }
        .onChange(of: selectedDurationIndex) { _ in
            // Reset the timer when the selected duration changes
            elapsedTime = 0.0
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}

