//
//  CoreDataManager.swift
//  WorkoutDiary
//
//  Created by Arin Rahim on 2023-12-20.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    
    @Published var workouts: [WorkOutEntity] = []
    @Published var exerciseDetails: [ExerciseDetailEntity] = []

    let persistentContainer: NSPersistentContainer
    

    init() {
        persistentContainer = NSPersistentContainer(name: "WorkOutCoreData")
        setupPersistentContainer()
    }

    func saveWorkoutToCoreData(workoutCoreData: WorkOutCoreData) {
        let context = persistentContainer.viewContext
        let workout = WorkOutEntity(context: context)

        workout.exercise = workoutCoreData.exercise
        workout.muscle = workoutCoreData.muscle

        do {
            try context.save()
        } catch {
            print("Failed to save to Core Data: \(error)")
        }
    }
    
    func saveExerciseDetailToCoreData(exerciseDetailCoreData: ExerciseDetailCoreData) {
        let context = persistentContainer.viewContext

        // Create ExerciseDetailEntity
        let exerciseDetail = ExerciseDetailEntity(context: context)
        exerciseDetail.id = exerciseDetailCoreData.id
        exerciseDetail.reps = exerciseDetailCoreData.reps
        exerciseDetail.sets = exerciseDetailCoreData.sets
        exerciseDetail.weigth = exerciseDetailCoreData.weight
        
        for workOutCoreData in exerciseDetailCoreData.workout {
            // Fetch existing WorkOutEntity based on exercise and muscle names
            if let existingWorkout = fetchWorkOutEntity(exercise: workOutCoreData.exercise, muscle: workOutCoreData.muscle) {
                // Connect existing WorkOutEntity to ExerciseDetailEntity
                exerciseDetail.addToExerciseToWorkout(existingWorkout)
            } else {
                print("WorkOutEntity not found for \(workOutCoreData.exercise) and \(workOutCoreData.muscle)")
                // Handle the case when WorkOutEntity is not found
            }
        }

        do {
            try context.save()
            //fetchExerciseDetails() // Update the list of exercise details
        } catch {
            print("Failed to save exercise detail to Core Data: \(error)")
        }
    }
    
    func fetchWorkOutEntity(exercise: String, muscle: String) -> WorkOutEntity? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WorkOutEntity> = WorkOutEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "exercise == %@ AND muscle == %@", exercise, muscle)

        do {
            let existingWorkouts = try context.fetch(fetchRequest)
            return existingWorkouts.first
        } catch {
            print("Error fetching WorkOutEntity: \(error)")
            return nil
        }
    }
    
    func fetchExerciseDetails()
    {
            let context = persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ExerciseDetailEntity> = ExerciseDetailEntity.fetchRequest()

            do {
                exerciseDetails = try context.fetch(fetchRequest)
                for exerciseDetail in exerciseDetails {
                    // Accessing attributes and relationships
                    _ = exerciseDetail.id
                    _ = exerciseDetail.reps
                    _ = exerciseDetail.sets
                    _ = exerciseDetail.weigth

                    print(exerciseDetail)
                }
            } catch {
                print("Failed to fetch exercise details from Core Data: \(error)")
                exerciseDetails = []
            }
        }
    
    func fetchWorkouts() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WorkOutEntity> = WorkOutEntity.fetchRequest()


        do {
            workouts = try context.fetch(fetchRequest)
               for workout in workouts {
                   // Accessing attributes to fire faults and load data
                   _ = workout.exercise
                   _ = workout.muscle
                   _ = workout.workoutToExercise?.sets
                   _ = workout.workoutToExercise?.reps
                   print(workout)
               }
        } catch {
            print("Failed to fetch workouts from Core Data: \(error)")
            workouts = []
        }
    }
    
    private func setupPersistentContainer() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
    }
    
   /* func deleteAllData() {
           let context = persistentContainer.viewContext

           // Create a fetch request for all entities
           let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "WorkOutEntity")

           // Create a batch delete request
           let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

           do {
               // Execute the batch delete request
               try context.execute(batchDeleteRequest)

               // Save the changes to persist the deletion
               try context.save()
           } catch {
               print("Failed to delete all data from Core Data: \(error)")
           }
       }*/
}

struct WorkOutCoreData
{
    var exercise: String
    var muscle: String
}

struct ExerciseDetailCoreData
{
    var id: UUID
    var weight: String
    var reps: String
    var sets: String
    var workout: [WorkOutCoreData]
    
}
