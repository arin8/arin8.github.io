//
//  WorkoutPickerView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-27.
//
import SwiftUI

struct WorkoutPickerView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var selectedWorkoutIndex: Int?
    @State private var isAddingWorkout = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.savedWorkouts.indices, id: \.self) { index in
                        NavigationLink(
                            destination: StartWorkoutView(workout: viewModel.savedWorkouts[index], viewModel: viewModel),
                            tag: index,
                            selection: $selectedWorkoutIndex
                        ) {
                            Text(viewModel.savedWorkouts[index].workoutName)
                                .onTapGesture {
                                    selectedWorkoutIndex = index
                                }
                        }
                    }
                    .onDelete(perform: deleteWorkouts)
                }
                .background(LinearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all))
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Pick a Workout")
            .navigationBarItems(
                leading: EditButton(),
                trailing: HStack {
                    Button(action: {
                        isAddingWorkout = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isAddingWorkout) {
                        AddWorkoutView(viewModel: viewModel)
                    }
                }
            )
        }
    }

    func deleteWorkouts(at offsets: IndexSet) {
        viewModel.savedWorkouts.remove(atOffsets: offsets)
    }
}

struct WorkoutPickerView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPickerView(viewModel: ViewModel())
    }
}



