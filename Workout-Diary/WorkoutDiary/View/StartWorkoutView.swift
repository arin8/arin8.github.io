//
//  StartWorkoutView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-29.
//

import SwiftUI

struct StartWorkoutView: View {
    @State private var workout: Workout
    @ObservedObject var viewModel: ViewModel
    @State private var isShowingExerciseList = false
    @State private var isPresentingStartWorkout = false

    func updateSets(for exercise: Exercise, to newCount: Int) {
        if let index = workout.exercises.firstIndex(where: { $0.id == exercise.id }) {
            var exercise = workout.exercises[index]
            exercise.sets = Array(repeating: ExerciseSet(id: UUID(), weight: "", reps: ""), count: newCount)
            workout.exercises[index] = exercise
        }
    }

    init(workout: Workout, viewModel: ViewModel) {
        self._workout = State(initialValue: workout)
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            List {
                ForEach(workout.exercises) { exercise in
                    Section(header: Text(exercise.name)) {
                        Stepper("Sets \(exercise.sets.count)", onIncrement: {
                            updateSets(for: exercise, to: exercise.sets.count + 1)
                        }, onDecrement: {
                            if exercise.sets.count > 0 {
                                updateSets(for: exercise, to: exercise.sets.count - 1)
                            }
                        })
                    }
                }
            }
            .navigationTitle(workout.workoutName)
            .navigationBarItems(
                trailing:
                Button(action: {
                    isShowingExerciseList.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .fullScreenCover(isPresented: $isShowingExerciseList) {
                    ExerciseListView(viewModel: viewModel, selectedExercises: $workout.exercises, isPresented: $isShowingExerciseList)
                }
            )
            
            Spacer()
            
            Button(action: {
                let startedWorkout = Workouts(id: UUID(), date: Date(), workout: workout)
                viewModel.startWorkout(workout: startedWorkout)
                isPresentingStartWorkout.toggle()
            }) {
                Text("Start Workout")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .fullScreenCover(isPresented: $isPresentingStartWorkout) {
                if let workout = viewModel.inProgressWorkout {
                    StartedWorkoutView(
                        viewModel: viewModel,
                        selectedWorkout: Binding(
                            get:{ workout },
                            set: { viewModel.inProgressWorkout = $0 }
                        ) as Binding<Workouts>,
                        isPresented: $isPresentingStartWorkout
                    )
                }
            }
        }
    }
}

struct ExerciseListView: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var selectedExercises: [Exercise]
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.muscleGroups, id: \.id) { muscleGroup in
                    Section(header: Text(muscleGroup.name)) {
                        ForEach(muscleGroup.exercises, id: \.id) { exercise in
                            Button(action: {
                                selectedExercises.append(exercise)
                                isPresented = false
                            }) {
                                Text(exercise.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarItems(trailing: Button("Done") {
                viewModel.saveWorkout(workout: Workout(id: UUID(), workoutName: "Custom Workout", workoutRating: 0.0, exercises: selectedExercises))
                isPresented = false
            })
        }
    }
}

struct StartWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StartWorkoutView(workout: Workout(id: UUID(), workoutName: "Push", workoutRating: 1.0, exercises: [Exercise(id: UUID(), name: "bench", sets: [ExerciseSet(id: UUID(), weight: "", reps: "")]), Exercise(id: UUID(), name: "Dips", sets: [ExerciseSet(id: UUID(), weight: "", reps: ""), ExerciseSet(id: UUID(), weight: "", reps: "")])]), viewModel: ViewModel())
        }
    }
}

