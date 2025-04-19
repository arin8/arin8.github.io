//
//  AddWorkoutView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-27.
//

import SwiftUI

struct AddWorkoutView: View {
    
    @State private var workoutName = ""
    @State private var exercises = [Exercise]()
    @StateObject var viewModel: ViewModel
    
    @State private var selectedMuscleGroup: MuscleGroup? = nil
    
    @State private var selectedExercise: Exercise? = nil
    @State private var selectedExercises = Set<Exercise>()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    TextField("Workout Name", text: $workoutName)
                }
                
                Section(header: Text("Exercises")) {
                    
                    ForEach(viewModel.muscleGroups) { muscleGroup in
                        
                        Section(header:
                            HStack {
                                Text(muscleGroup.name)
                                Spacer()
                                Image(systemName: self.selectedMuscleGroup?.id == muscleGroup.id ? "chevron.down" : "chevron.right")
                            }
                            .onTapGesture {
                                self.selectedMuscleGroup = (self.selectedMuscleGroup == muscleGroup) ? nil : muscleGroup
                            }
                        ) {
                            
                            if self.selectedMuscleGroup?.id == muscleGroup.id {
                                
                                ForEach(muscleGroup.exercises) { exercise in
                                    
                                    NavigationLink(destination: EmptyView()) {
                                        HStack {
                                            Text(exercise.name)
                                            Spacer()
                                            if selectedExercises.contains(exercise) {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                    .onTapGesture {
                                        if selectedExercises.contains(exercise) {
                                            selectedExercises.remove(exercise)
                                        } else {
                                            selectedExercises.insert(exercise)
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                Section(header: Text("Added Exercises")) {
                    ForEach(Array(selectedExercises)) { exercise in
                        Text(exercise.name)
                    }
                }
                
                Section {
                    Button("Save Workout") {
                        let workout = Workout(id: UUID(), workoutName: self.workoutName, workoutRating: 1.0, exercises: Array(self.selectedExercises))
                        // Save workout
                        selectedExercises = []
                        viewModel.saveWorkout(workout: workout)
                        workoutName = ""
                        
                        // Close the view after saving the workout
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                }
                
            }
            .background(LinearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all))
            .scrollContentBackground(.hidden)
            .navigationTitle("Add Workout")
        }
    }
}

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutView(viewModel: ViewModel())
    }
}
