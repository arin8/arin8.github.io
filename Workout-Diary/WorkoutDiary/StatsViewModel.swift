//
//  StatsViewModel.swift
//  WorkoutDiary
//
//  Created by Arin Rahim on 2024-01-04.
//

import Foundation
import SwiftUI

class StatsViewModel: ObservableObject
{
    @Published var workouts: [StatsData] = []
    
    /*init()
    {
        generateData()
    }*/

    /*func generateData()
    {
        let currentDate = Date()
        let lastMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        let randomWorkoutCount = Int.random(in: 5...15)

        for _ in 0..<randomWorkoutCount {
            let randomTimeInterval = TimeInterval(arc4random_uniform(UInt32(currentDate.timeIntervalSince(lastMonthDate))))
            _ = Date(timeInterval: randomTimeInterval, since: lastMonthDate)

            let randomExercise = ["Squats", "Deadlift", "Bench press"].randomElement()!
            let randomSets = Int.random(in: 3...5)
            let randomReps = Int.random(in: 5...15)
            let randomWeight = Int.random(in: 20...100)

            //let statsData = StatsData(sets: randomSets, reps: randomReps, weight: randomWeight, exercise: randomExercise)
            //workouts.append(statsData)
            //print(workouts)
        }
    }*/
}

struct StatsData: Identifiable
{
    var id: Int {day}
    var sets: Int
    var reps: Int
    var day: Int
    
    static var setsExample: [StatsData]
    {
        [StatsData(sets: 9, reps: 90, day: 1),
        StatsData(sets: 12, reps: 120, day: 2),
        StatsData(sets: 6, reps: 60 , day: 3),
        StatsData(sets: 0, reps: 0, day: 4),
        StatsData(sets: 0, reps: 0, day: 5),
        StatsData(sets: 12, reps: 48, day: 6),
        StatsData(sets: 10, reps: 50, day: 7),
        StatsData(sets: 0, reps: 0, day: 8),
        StatsData(sets: 15, reps: 75, day: 9),
        StatsData(sets: 9, reps: 45, day: 10),
        StatsData(sets: 0, reps: 0, day: 11),
        StatsData(sets: 0, reps: 0, day: 12),
        StatsData(sets: 12, reps: 48, day: 13),
        StatsData(sets: 10, reps: 60, day: 14),
        StatsData(sets: 12, reps: 72, day: 15),
        StatsData(sets: 0, reps: 0, day: 16),
        StatsData(sets: 0, reps: 0, day: 17),
        StatsData(sets: 12, reps: 120, day: 18),
        StatsData(sets: 12, reps: 180, day: 19),
        StatsData(sets: 0, reps: 0, day: 20),
        StatsData(sets: 14, reps: 140, day: 21),
        StatsData(sets: 15, reps: 150, day: 22),
        StatsData(sets: 0, reps: 0, day: 23),
        StatsData(sets: 9, reps: 45, day: 24),
        StatsData(sets: 12, reps: 86, day: 25),
        StatsData(sets: 0, reps: 0, day: 26),
        StatsData(sets: 0, reps: 0, day: 27),
        StatsData(sets: 15, reps: 150, day: 28),
        StatsData(sets: 12, reps: 120, day: 29),
        StatsData(sets: 0, reps: 0, day: 30),
        StatsData(sets: 10, reps: 100, day: 31)]
    }
}

struct PieChartMuscleGroup: Identifiable
{
    var id: Double { precantage }
    var muscleGroup: String
    var precantage: Double
    var color: Color
    
    static var muscleGroups: [PieChartMuscleGroup]
    {
        [PieChartMuscleGroup(muscleGroup: "Quadriceps", precantage: 35.0, color: .gray),
        PieChartMuscleGroup(muscleGroup: "Triceps", precantage: 10.0, color: .green),
        PieChartMuscleGroup(muscleGroup: "Biceps", precantage: 5.0, color: .pink),
        PieChartMuscleGroup(muscleGroup: "Abs", precantage: 5.0, color: .orange),
        PieChartMuscleGroup(muscleGroup: "Chest", precantage: 20.0, color: .brown),
        PieChartMuscleGroup(muscleGroup: "Lats", precantage: 10.0, color: .mint),
        PieChartMuscleGroup(muscleGroup: "Glutes", precantage: 15.0, color: .indigo)]
    }
}


