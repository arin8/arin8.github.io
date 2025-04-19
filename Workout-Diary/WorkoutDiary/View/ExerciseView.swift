//
//  ExerciseView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-17.
//

import SwiftUI

struct ExerciseView: View {
    @State private var exercises: [String] = ["bench", "dips"]
    @State private var exerciseEntries: [String: [WorkoutSet]] = [:]
    @State private var weight = ""
    @State private var reps = ""

    var body: some View {
        List {
            ForEach(exercises, id: \.self) { exercise in
                Section(header: Text(exercise)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                ) {
                    ForEach(exerciseEntries[exercise] ?? [], id: \.self) { exerciseEntry in
                        HStack {
                            TextField("Weight", text: Binding(
                                get: { exerciseEntry.weightString },
                                set: { exerciseEntries[exercise]![0].weightString = $0 }
                            ))
                            .keyboardType(.numberPad)
                            Text("kg")

                            Spacer()

                            TextField("Reps", text: Binding(
                                get: { exerciseEntry.repsString },
                                set: { exerciseEntries[exercise]![0].repsString = $0 }
                            ))
                            .keyboardType(.numberPad)
                            Text("reps")
                        }
                    }
                    .listRowBackground(Color.gray)

                    HStack {
                        TextField("Weight", text: $weight)
                            .keyboardType(.numberPad)
                        Text("kg")

                        Spacer()

                        TextField("Reps", text: $reps)
                            .keyboardType(.numberPad)
                        Text("reps")

                        Button(action: {
                            addSet(for: exercise)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(red: 0, green: 140/255, blue: 0))
                        }
                    }
                    .listRowBackground(Color.gray)
                }
            }
        }
        .background(LinearGradient(colors: [.blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all))
        .scrollContentBackground(.hidden)
    }

    func addSet(for exercise: String) {
        let weightValue = Double(weight) ?? 0.0
        let repsValue = Int(reps) ?? 0

        let newExercise = WorkoutSet(weight: weightValue, reps: repsValue)
        if var currentExercises = exerciseEntries[exercise] {
            currentExercises.append(newExercise)
            exerciseEntries[exercise] = currentExercises
        } else {
            exerciseEntries[exercise] = [newExercise]
        }

        // Clear the text fields after adding an exercise
        weight = ""
        reps = ""
    }
}

// Data structure for Exercise
struct WorkoutSet: Hashable {
    var weight: Double
    var reps: Int

    var weightString: String {
        get { weight == 0.0 ? "" : "\(weight)" }
        set { weight = Double(newValue) ?? 0.0 }
    }

    var repsString: String {
        get { reps == 0 ? "" : "\(reps)" }
        set { reps = Int(newValue) ?? 0 }
    }
}

#Preview {
    ExerciseView()
}
