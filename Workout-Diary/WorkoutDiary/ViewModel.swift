//
//  ViewModel.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-21.
//

import Foundation

class ViewModel : ObservableObject {
    
    var exercisesAPI = [ExercisesAPI]()
    @Published var exercises = [Exercise]() //Array for saving the exercises for each api call.
    @Published var muscleGroups = [MuscleGroup]() //Array for Saving all exercises for each muscle group.
    @Published var savedWorkouts = [Workout]() //Array for storing our workouts with name and all corresponding data.
    @Published var startedWorkouts = [Workouts]()
    @Published var inProgressWorkout: Workouts?
    
    var lastStartedWorkout: Workouts? {
        startedWorkouts.last
    }
    
    init() {
        getExercises(forMuscle: "biceps")
        getExercises(forMuscle: "chest")
        //getExercises(forMuscle: "lats")
        //getExercises(forMuscle: "quadriceps")
        //getExercises(forMuscle: "glutes")
        //getExercises(forMuscle: "forearms")
        //getExercises(forMuscle: "calves")
        savedWorkouts = [Workout(id: UUID(), workoutName: "Push", workoutRating: 1.0, exercises: [Exercise(id: UUID(), name: "Barbell Bench Press - Medium Grip", sets: [ExerciseSet(id: UUID(), weight: "", reps: "")]), Exercise(id: UUID(), name: "Pushups", sets: [ExerciseSet(id: UUID(), weight: "", reps: "")])]), Workout(id: UUID(), workoutName: "Biceps Workout", workoutRating: 1.0, exercises: [Exercise(id: UUID(), name: "Barbell Curl", sets: [ExerciseSet(id: UUID(), weight: "", reps: "")]), Exercise(id: UUID(), name: "Zottman Curl", sets: [ExerciseSet(id: UUID(), weight: "", reps: "")])])]
    }
    
    //Send in a defined muscle to get exercises
    func getExercises(forMuscle muscle: String) {
            NinjaAPI().loadData(muscle: muscle) { (exercises) in
                // This code is executed when the data is loaded
                var muscleGroupExercises = [Exercise]()

                // Process the loaded data
                for exercise in exercises {
                    let newExercise = Exercise(id: UUID(), name: exercise.name, sets: [ExerciseSet(id: UUID(), weight: "", reps: "")])
                    self.exercises.append(newExercise)
                    muscleGroupExercises.append(newExercise)
                }

                // Create a single MuscleGroup for the muscle and add the corresponding exercises
                let muscleGroup = MuscleGroup(id: UUID(), name: muscle, exercises: muscleGroupExercises)
                self.muscleGroups.append(muscleGroup)

                // Now the exercises array and muscleGroups array are populated correctly
                print("View exercises: \(self.exercises)")
                print("View muscleGroups: \(self.muscleGroups)")
            }
            // At this point, exercisesAPI may not be populated yet, so printing it here may show an empty array
            print(exercisesAPI)
    }
    
    // Function to save the workout to the array after defining it in the AddWorkoutView
    func saveWorkout(workout: Workout) {
        // Add to published array
        savedWorkouts.append(workout)
        print(savedWorkouts)

    }
    
    func updateWorkout(workout: Workout) {
        if let index = startedWorkouts.firstIndex(where: { $0.workout.id == workout.id }) {
            startedWorkouts[index].workout = workout
            print("Workout updated in ViewModel:", workout)
        }
    }
    
    func startWorkout(workout: Workouts) {
            inProgressWorkout = workout
        }

        func finishWorkout(workout: Workout) {

            if let current = inProgressWorkout, current.workout.id == workout.id {
                
                // Append copy to history to avoid mutation
                let finishedWorkout = Workouts(id: current.id,
                                               date: current.date,
                                               workout: current.workout)
                
                startedWorkouts.append(finishedWorkout)
                inProgressWorkout = nil
            }
        }
    
    func deleteWorkout(_ workout: Workouts) {
        if let index = startedWorkouts.firstIndex(where: { $0.id == workout.id }) {
            startedWorkouts.remove(at: index)
        }
    }

    
}
