//
//  ReorderExerciseView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2024-01-06.
//

import SwiftUI


struct ReorderExerciseView: View {
    @Binding var exercises: [Exercise]
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List {
                ForEach($exercises) { $exercise in
                    Text(exercise.name)
                        .onTapGesture {
                            // Handle tapping on an exercise in the list if needed
                        }
                }
                .onMove { indices, newOffset in
                    exercises.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
            .navigationTitle("Reorder Exercises")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: EditButton() // Enable Edit mode
            )
        }
    }
}




#Preview {
    ReorderExerciseView(exercises: .constant([Exercise(id: UUID(), name: "test", sets: [ExerciseSet(id: UUID(), weight: "", reps: "")]), Exercise(id: UUID(), name: "test2", sets: [ExerciseSet(id: UUID(), weight: "", reps: "")])]), isPresented: .constant(true))
}
