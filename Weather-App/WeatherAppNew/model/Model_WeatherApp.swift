//
//  Model_WeatherApp.swift
//  Weather app (git)
//
//  Created by Mathias Olsson on 2023-11-22.
//

import Foundation


struct WeatherData: Codable {
    
    let approvedTime: String
    let referenceTime: String
    let geometry: Geometry
    let timeSeries: [TimeSeries]?
    
}

struct Geometry: Codable {
    let type: String
    let coordinates: [[Double]]
}

struct TimeSeries: Codable {
    let validTime: String?
    let parameters: [Parameter]
}

struct Parameter: Codable {
    let name: String
    let levelType: String
    let level: Int
    let unit: String
    let values: [Double] // or [Int] or [String] depending on actual type
}



