//
//  ExerciseView2.swift
//  WorkoutDiary
//
//  Created by Mathias Olsson on 2023-12-17.
//

import SwiftUI

struct ExerciseView2: View {
    @State private var exercises: [Exercise] = [
        Exercise(id: UUID(), name: "Bench Press", sets: [
            ExerciseSet(id: UUID(), weight: "", reps: ""),
        ]),
        Exercise(id: UUID(), name: "Dips", sets: [
            ExerciseSet(id: UUID(), weight: "", reps: ""),
        ])
    ]

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(exercises.indices, id: \.self) { index in
                        Section(header: Text(exercises[index].name)) {
                            ForEach(exercises[index].sets.indices, id: \.self) { setIndex in
                                HStack {
                                    TextField("Weight", text: $exercises[index].sets[setIndex].weight)
                                        .keyboardType(.numberPad)
                                    
                                    Text("kg")
                                    Spacer()
                                    TextField("Reps", text: $exercises[index].sets[setIndex].reps)
                                        .keyboardType(.numberPad)
                                    
                                    Text("reps")
                                }
                                .listRowBackground(Color.gray)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        // Delete the set
                                        exercises[index].sets.remove(at: setIndex)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                            Button(action: {
                                // Add a new set to the current exercise
                                exercises[index].sets.append(ExerciseSet(id: UUID(), weight: "", reps: ""))
                            }) {
                                Text("Add Set")
                            }
                            .listRowBackground(Color(red: 0, green: 100/255, blue: 0))
                        }
                    }
                }
                .background(LinearGradient(colors: [.blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all))
                .scrollContentBackground(.hidden)
                
            }
            
            .navigationTitle("Exercise list")
            
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

struct ExerciseView2_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView2()
    }
}
