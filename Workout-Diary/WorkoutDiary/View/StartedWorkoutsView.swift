//
//  StartedWorkoutsView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-29.
//

import SwiftUI

struct StartedWorkoutsView: View {
    
    @ObservedObject var viewModel: ViewModel

    @State private var selectedWorkout: Workouts?
    @State private var isPresentingStartWorkout = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.startedWorkouts) { startedWorkout in
                    Section(header: Text("Started on \(startedWorkout.date)")) {
                        HStack {
                            Text(startedWorkout.workout.workoutName)
                                .font(.headline)
                                .foregroundStyle(Color.blue)
                                .onTapGesture {
                                    selectedWorkout = startedWorkout
                                    isPresentingStartWorkout = true
                                }

                            Spacer()

                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    deleteWorkout(startedWorkout)
                                }
                        }

                        ForEach(startedWorkout.workout.exercises) { exercise in
                            HStack {
                                Text(exercise.name)
                                Spacer()
                                Text("\(exercise.sets.count) sets")
                            }
                        }
                    }
                }
            }
            .background(LinearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all))
            .scrollContentBackground(.hidden)
            .navigationTitle("Started Workouts")
            .sheet(item: $selectedWorkout) { workout in
                if let index = viewModel.startedWorkouts.firstIndex(where: { $0.id == workout.id }) {
                    StartedWorkoutView(
                        viewModel: viewModel,
                        selectedWorkout: $viewModel.startedWorkouts[index],
                        isPresented: $isPresentingStartWorkout
                    )
                }
            }
        }
    }

    // Function to delete a workout
    private func deleteWorkout(_ workout: Workouts) {
        viewModel.deleteWorkout(workout)
    }
}



struct StartedWorkoutsView_Previews: PreviewProvider {

    static var previews: some View {
        
        let viewModel = ViewModel()
        
        viewModel.startedWorkouts = [
            Workouts(id: UUID(), date: Date(), workout: Workout(id: UUID(), workoutName: "Push", workoutRating: 1.0, exercises: [Exercise(id: UUID(), name: "bench press", sets: [ExerciseSet(id: UUID(), weight: "", reps: "")])]))
        ]

        return StartedWorkoutsView(viewModel: viewModel)
    }

}
