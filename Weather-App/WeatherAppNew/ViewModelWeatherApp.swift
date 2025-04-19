//
//  ViewModelWeatherApp.swift
//  WeatherAppNew
//
//  Created by Mathias Olsson on 2023-12-03.
//

//
//  ViewModel_WeatherApp.swift
//  Weather app (git)
//
//  Created by Mathias Olsson on 2023-11-22.
//

import Foundation
import Network
import CoreData

class ViewModel_WeatherApp : ObservableObject {
    
    let container: NSPersistentContainer
    
    // Creating varibles background and main to use for threading...
    let background = DispatchQueue.global(qos: .background)
    let main = DispatchQueue.main
    private var isConnnected: Bool
    //@Published var weatherObject: Model_WeatherApp?
    //@Published var date: String = "-"
    //@Published var temp: String = "-"
    @Published var approvedTime: String = "-"
    //@Published var parameterArray: [Parameter]?
    @Published var weatherDays : [Weather] = []
    
    init () 
    {
        container = NSPersistentContainer(name: "WeatherAppNew")
        container.loadPersistentStores 
        { (description, error) in
            
            if let error = error
            {
                print("Failed to load the data\(error)")
            } 
            else
            {
                print("successfully loaded core data")
            }
        }
        isConnnected = false
        //deleteAllWeather()
        checkinternet()
        if isConnnected == false {
            fetchWeatherDatabase()
        }
        //fetchweather(lat: "59", long: "18")
        //fetchWeatherDatabase()
    }
    
    // Struct with attributs that will be shown to the user...
    struct WeatherDaySave {
        let date: String
        let temp: String
        let Wsymb2: String
        
    }
    
    func submitCoordinates(latitude: String, longitude: String) {
        
        //print("Latitude: \(latitude), Longitude: \(longitude)")
        fetchweather(lat: latitude, long: longitude)
        main.async {
            self.objectWillChange.send()
        }
        //print(weatherDays)
        //fetchWeatherDatabase()
    }
    
    // Adding weather data to Core Data...
    func addWeather(weatherday: WeatherDaySave)
    {
        deleteAllWeather() //deletes all weather from datbase before inserting new data
        main.async {
            let weather = Weather(context: self.container.viewContext)
            // weather.id = UUID()
            weather.date = String(weatherday.date)
            weather.temp = String(weatherday.temp)
            weather.wsymb2 = String(weatherday.Wsymb2)
            self.savedata()
        }
    }
    
    // Fetching weather data from Core Data...
    func fetchWeatherDatabase()
    {
        let request = NSFetchRequest<Weather>(entityName: "Weather")
        weatherDays = []
        do
        {
            self.weatherDays = try self.container.viewContext.fetch(request)
            //print(weatherDays)
        }
        catch let error
        {
            print("error fetching. \(error)")
        }
    }
    
    // Deleting weather data from Core Data...
    func deleteAllWeather() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try! self.container.viewContext.execute(deleteRequest)
    }
    
    // Saving weather data in Core Data
    func savedata()
    {
        do
        {
            try self.container.viewContext.save()
            self.fetchWeatherDatabase()
            print("Data saved!")
        }
        catch
        {
            print("Could not save the data")
        }
    }
    
    
    func fetchweather(lat: String, long: String)
    {
        background.async {
            guard let url = URL(string: "https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/\(long)/lat/\(lat)/data.json") else
            {
                return
            }
            
            // Create a URLSession configuration
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error
                {
                    print("Error: \(error.localizedDescription)")
                }
                else if let data = data
                {
                    if let dataString = String(data: data, encoding: .utf8)
                    {
                        self.main.async {
                            self.decodeJSON(data: data)
                        }
                        //print("Data received: \(dataString)")
                    }
                }
            }
            task.resume()
            session.finishTasksAndInvalidate()
        }
        
    }
            
    func decodeJSON(data: Data) 
    {
        do 
        {
            let model = try JSONDecoder().decode(WeatherData.self, from: data)
            
                
                if let timeSeries = model.timeSeries 
                {
                    //self.weatherDays = [] // clear
                        for series in timeSeries
                    {
                            if let validTime = series.validTime,
                                let tempParam = series.parameters.first(where: {$0.name == "t"}),
                                let wsymb2Param = series.parameters.first(where: {$0.name == "Wsymb2"})
                            {
                            if let temp = tempParam.values.first,
                                let wsymb2 = wsymb2Param.values.first 
                                {
                                let day = WeatherDaySave(date: String(validTime), temp: String(temp), Wsymb2: String(wsymb2))
                                self.addWeather(weatherday: day)
                            }
                        }
                    }
                }
            
            self.main.async {
                self.approvedTime = model.approvedTime //should be only one value
            }
                
        }
        catch {
            print("failed\(error)")
        }
    }
    
    
    func checkinternet()
    {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler =
        { path in
            if path.status == .satisfied
            {
                print("We're connected!")
                self.isConnnected = true
            }
            else
            {
                print("No connection.")
                self.isConnnected = false
            }
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}

