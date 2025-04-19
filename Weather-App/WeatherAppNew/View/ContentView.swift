//
//  ContentView.swift
//  Weather app (git)
//
//  Created by Mathias Olsson on 2023-11-22.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
    @ObservedObject private var theViewModel = ViewModel_WeatherApp()
        
    var body: some View {
        NavigationView {
            List {
                Text("Weather Forecast")
                         .font(.largeTitle)
                Section(header: LocationStackView(viewModel: theViewModel)) {
                    ForEach(theViewModel.weatherDays) { day in
                        
                        VStack {
                            Text(day.date ?? "No date")
                            HStack {
                                WeatherView().symbolManager.getWeatherImage(forWsymb2: day.wsymb2 ?? "1.0").font(.largeTitle)
                                Text("\(day.temp ?? "No temp")°C").font(.title).bold()
                                
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

