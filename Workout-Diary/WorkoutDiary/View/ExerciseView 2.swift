//
//  ExceriseView.swift
//  WorkoutDiary
//
//  Created by Arin Rahim on 2023-12-17.
//

import SwiftUI

struct Exercise: Identifiable {
    let id = UUID()
    var name: String
    var weight: Double
    var reps: Int
}

struct ExerciseView: View {
    @State private var exercises: [Exercise] = []
    @State private var newExerciseWeight = ""
    @State private var newExerciseReps = ""

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Weight", text: $newExerciseWeight)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)

                TextField("Reps", text: $newExerciseReps)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)

                Button("Add Exercise") {
                    addExercise()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()

            List {
                ForEach(exercises) { exercise in
                    Text("\(exercise.name): \(exercise.weight) lbs, Reps: \(exercise.reps)")
                }
            }
            .padding()
        }
        .navigationBarTitle("Exercise List")
    }

    func addExercise() {
        guard let weightValue = Double(newExerciseWeight), let repsValue = Int(newExerciseReps) else {
            // Handle invalid input
            return
        }

        let newExercise = Exercise(name: "New Exercise", weight: weightValue, reps: repsValue)
        exercises.append(newExercise)
        clearFields()
    }

    func clearFields() {
        newExerciseWeight = ""
        newExerciseReps = ""
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView()
    }
}
