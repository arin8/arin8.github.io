//
//  TestView2.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2024-01-02.
//


import SwiftUI

struct Test2View: View {

    @State var exerciseDetails = [ExerciseDetailEntity]()
    @State var query: String = ""
    @ObservedObject var coreData = CoreDataManager()
    //@ObservedObject var ninjaAPI = NinjaAPI()
    var muscle = "Triceps"
    
    func addTestExerciseDetails() {
        let testExerciseDetails: [ExerciseDetailCoreData] = [
            ExerciseDetailCoreData(
                id: UUID(),
                weight: "10 kg",
                reps: "10",
                sets: "3",
                workout: [
                    WorkOutCoreData(exercise: "Dumbbell floor press", muscle: "Triceps"),
                    WorkOutCoreData(exercise: "dips", muscle: "triceps/chest")
                ]
            ),
            ExerciseDetailCoreData(id: UUID(), weight: "5", reps: "5", sets: "2", workout: [WorkOutCoreData(exercise: "bench", muscle: "chest")])
        ]
        
        // Save the test data
        for exerciseDetail in testExerciseDetails {
            coreData.saveExerciseDetailToCoreData(exerciseDetailCoreData: exerciseDetail)
        }
        
        // Fetch and update the exercise details
        coreData.fetchWorkouts()
        exerciseDetails = coreData.exerciseDetails
    }

    var body: some View {
        VStack {
            Button("Add Test Data") {
                addTestExerciseDetails()
            }
        }
    }
}


#Preview {
    Test2View()
}
