//
//  WeatherAppNewApp.swift
//  WeatherAppNew
//
//  Created by Mathias Olsson on 2023-12-03.
//

import SwiftUI

@main
struct WeatherAppNewApp: App {
    //let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
