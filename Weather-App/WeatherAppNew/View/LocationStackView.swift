//
//  LocationStackView.swift
//  Weather app (git)
//
//  Created by Mathias Olsson on 2023-11-23.
//

import SwiftUI

struct LocationStackView: View {
    
    var viewModel: ViewModel_WeatherApp
    
    @State private var longitude: Float = 0.0
    @State private var latitude: Float = 0.0
    
    var body: some View {
        HStack {
            
            TextField("Enter lat", value: $latitude, formatter: NumberFormatter())
                .textFieldStyle(.roundedBorder)
                .frame(width: 100)
            TextField("Enter lon", value: $longitude, formatter: NumberFormatter())
                .textFieldStyle(.roundedBorder)
                .frame(width: 100)
            Button("Submit") {
                viewModel.submitCoordinates(latitude: String(latitude), longitude: String(longitude))
                latitude = 0.0
                longitude = 0.0
            }
            .buttonStyle(.bordered)
            .controlSize(.regular)
            .foregroundColor(.blue)
            .background(Color.gray.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct LocationStackView_Previews : PreviewProvider {
    static var previews: some View {
        LocationStackView(viewModel: ViewModel_WeatherApp())
    }
}

