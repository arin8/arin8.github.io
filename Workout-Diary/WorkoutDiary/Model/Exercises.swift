//
//  Exercises.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-17.
//

import Foundation

struct Workouts: Hashable, Equatable, Identifiable {
    var id: UUID
    var date: Date
    var workout: Workout
}

struct Workout: Hashable, Equatable, Identifiable {
    var id: UUID
    var workoutName: String
    var workoutRating: Double
    var exercises: [Exercise]
}

struct MuscleGroup: Hashable, Identifiable {
    var id: UUID
    var name: String
    var exercises: [Exercise]
}

struct ExerciseSet: Identifiable, Equatable, Hashable {
    var id: UUID
    var weight: String
    var reps: String
}

struct Exercise: Identifiable, Equatable, Hashable {
    var id: UUID
    var name: String
    var sets: [ExerciseSet]
}
