//
//  IntensitySelectionView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2024-01-06.
//

import SwiftUI

struct IntensitySelectionView: View {
    @Binding var workout: Workout
    @State private var workoutRating: Double = 1.0 // Default value

    var body: some View {
        VStack {
            Text("How well did the workout feel?")
                .padding()

            Slider(value: $workout.workoutRating, in: 1...10, step: 1)
                .accentColor(Color(hue: 0.33 * (1 - workout.workoutRating/10), saturation: 1.0, brightness: 1.0))
                .padding(.horizontal)
            HStack {
                Text("Easy")
                Spacer()
                Text("Hard")
            }
            .padding(.horizontal)

            Text("Rating: \(Int(workout.workoutRating))")
                .padding()
                .foregroundColor(Color(hue: 0.33 * (1 - workout.workoutRating/10), saturation: 1.0, brightness: 1.0))
        }
    }
}

struct WorkoutSliderView_Previews: PreviewProvider {
    static var previews: some View {
        IntensitySelectionView(workout: .constant(Workout(id: UUID(), workoutName: "", workoutRating: 2.0, exercises: [Exercise(id: UUID(), name: "", sets: [ExerciseSet(id: UUID(), weight: "", reps: "")])])))
    }
}






