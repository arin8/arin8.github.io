//
//  ExercisesListView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-18.
//

import SwiftUI

struct WorkoutListView: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            List(viewModel.muscleGroups, id: \.self) { group in
                NavigationLink(destination: WorkoutDetail(muscleGroup: group)) {
                    Text(group.name)
                }
            }
            .background(LinearGradient(colors: [.blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all))
            .scrollContentBackground(.hidden)
            .navigationTitle("Exercise List")
        }
    }
}

struct WorkoutDetail: View {

    var muscleGroup: MuscleGroup
    
    var body: some View {
        List(muscleGroup.exercises) { exercise in
            Text("Exercise: \(exercise.name)")
                .listRowBackground(Color.gray)
        }
        .background(LinearGradient(colors: [.blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all))
        .scrollContentBackground(.hidden)
        .navigationTitle(muscleGroup.name)
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView(viewModel: ViewModel())
    }
}



