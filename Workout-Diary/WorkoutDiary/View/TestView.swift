//
//  TestView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-18.
//

import SwiftUI

struct TestView: View {

    @State var exercises = [ExercisesAPI]()
    @State var query: String = ""
    @ObservedObject var coreData = CoreDataManager()
    @ObservedObject var ninjaAPI = NinjaAPI()
    var muscle = "Triceps"
    
    func getExercises() {
        NinjaAPI().loadData(muscle: "biceps") { (exercises) in
            self.exercises = exercises
        }
    }

    var body: some View {
        Button("Button") {
            //getExercises()
            //print(exercises)
            coreData.fetchWorkouts()
            //coreData.deleteAllData()
            
        }
    }
}

#Preview {
    TestView()
}
