//
//  WorkoutView.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-17.
//

import SwiftUI

struct WorkoutView: View {
    @StateObject var viewModel: ViewModel
    @State private var selectedMuscleGroup = "Biceps"
    var body: some View {
        NavigationView {
            VStack {
                
                List {
                    ForEach(viewModel.exercises.indices, id: \.self) { index in
                        Section(header: Text(viewModel.exercises[index].name).font(.headline)
                            .bold()) {
                            ForEach(viewModel.exercises[index].sets.indices, id: \.self) { setIndex in
                                HStack {
                                    TextField("Weight", text: $viewModel.exercises[index].sets[setIndex].weight)
                                        .keyboardType(.numberPad)

                                    Text("kg")
                                    Spacer()
                                    TextField("Reps", text: $viewModel.exercises[index].sets[setIndex].reps)
                                        .keyboardType(.numberPad)

                                    Text("reps")
                                }
                                .listRowBackground(Color.gray)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        // Delete the set
                                        viewModel.exercises[index].sets.remove(at: setIndex)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                            Button(action: {
                                // Add a new set to the current exercise
                                viewModel.exercises[index].sets.append(ExerciseSet(id: UUID(), weight: "", reps: ""))
                            }) {
                                Text("Add Set")
                            }
                            .listRowBackground(Color(red: 0, green: 100/255, blue: 0))
                        }
                    }
                }
                .background(LinearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all))
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Exercise list")
            .navigationBarItems(trailing:
            HStack {
                Text(selectedMuscleGroup)
                Menu {
                    Picker("Choose muscle", selection: $selectedMuscleGroup) {
                        Text("Biceps").tag("Biceps")
                        Text("Chest").tag("Chest")
                    }
                } label: {
                    Image(systemName: "chevron.down")
                }
            }
            )
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

#Preview {
    WorkoutView(viewModel: ViewModel())
}
