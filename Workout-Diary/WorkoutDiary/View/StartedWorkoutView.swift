//
//  StartedWorkoutView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-30.
//

import SwiftUI

struct StartedWorkoutView: View {

    @ObservedObject var viewModel: ViewModel
   
    @Binding var selectedWorkout: Workouts

    @Binding var isPresented: Bool
    
    @State private var isSliderViewPresented: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(selectedWorkout.workout.exercises.indices, id: \.self) { exerciseIndex in
                        let exercise = selectedWorkout.workout.exercises[exerciseIndex]

                        Section(header: Text(exercise.name)) {
                            ForEach(exercise.sets.indices, id: \.self) { setIndex in
                                HStack {
                                    TextField("Weight", text: Binding(
                                        get: {
                                            exercise.sets[setIndex].weight
                                        },
                                        set: {
                                            selectedWorkout.workout.exercises[exerciseIndex].sets[setIndex].weight = $0
                                        }
                                    ))
                                    .keyboardType(.numberPad)
                                    Text("kg")
                                    
                                    TextField("Reps", text: Binding(
                                        get: {
                                            exercise.sets[setIndex].reps
                                        },
                                        set: {
                                            selectedWorkout.workout.exercises[exerciseIndex].sets[setIndex].reps = $0
                                        }
                                    ))
                                    .keyboardType(.numberPad)
                                    Text("reps")
                                }
                                
                                .swipeActions {
                                    Button("Delete", role: .destructive) {
                                        selectedWorkout.workout.exercises[exerciseIndex].sets.remove(at: setIndex)
                                    }
                                }
                                
                            }

                            Button("Add Set") {
                                selectedWorkout.workout.exercises[exerciseIndex].sets.append(ExerciseSet(id: UUID(), weight: "", reps: ""))
                            }
                            
                        }
                    }
                    Section() {
                        IntensitySelectionView(workout: $selectedWorkout.workout)
                    }
                }
                
                .navigationTitle("\(selectedWorkout.workout.workoutName)")
                
            }
            
            .navigationBarItems(trailing:
                
                Button("Done") {
                   isPresented = false
                }
                
            )
            
        }
        
        .onDisappear {
            viewModel.finishWorkout(workout: selectedWorkout.workout)
        }
        .scrollDismissesKeyboard(.immediately)
    }
}


struct StartedWorkoutView_Previews: PreviewProvider {

    static var previews: some View {
        StartedWorkoutView(
           viewModel: ViewModel(),
           selectedWorkout: .constant(
            Workouts(id: UUID(), date: Date(), workout: Workout(id: UUID(), workoutName: "", workoutRating: 1.0, exercises: [Exercise(id: UUID(), name: "", sets: [ExerciseSet(id: UUID(), weight: "", reps: "")])]))
           ),
           isPresented: .constant(false)
        )
    }

}

