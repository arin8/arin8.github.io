//
//  WeatherView.swift
//  Weather app (git)
//
//  Created by Mathias Olsson on 2023-11-23.
//

import SwiftUI


class WeatherSymbolManager {

    func getWeatherImage(forWsymb2: String) -> Image {
        switch forWsymb2 {
        case "1.0":
            return Image(systemName: "sun.max")
        case "2.0":
            return Image(systemName: "cloud.sun")
        case "3.0":
            return Image(systemName: "cloud.sun")
        case "4.0":
            return Image(systemName: "cloud.sun.fill")
        case "5.0":
            return Image(systemName: "cloud")
        case "6.0":
            return Image(systemName: "cloud")
        case "7.0":
            return Image(systemName: "cloud.fog")
        case "8.0":
            return Image(systemName: "cloud.drizzle")
        case "9.0":
            return Image(systemName: "cloud.rain")
        case "10.0":
            return Image(systemName: "cloud.heavyrain")
        case "11.0":
            return Image(systemName: "cloud.bolt")
        case "12.0":
            return Image(systemName: "cloud.sleet")
        case "13.0":
            return Image(systemName: "cloud.sleet.fill")
        case "14.0":
            return Image(systemName: "cloud.sleet.fill")
        case "15.0":
            return Image(systemName: "sun.snow")
        case "16.0":
            return Image(systemName: "cloud.snow")
        case "17.0":
            return Image(systemName: "cloud.snow.fill")
        case "18.0":
            return Image(systemName: "cloud.drizzle")
        case "19.0":
            return Image(systemName: "cloud.rain")
        case "20.0":
            return Image(systemName: "cloud.heavyrain")
        case "21.0":
            return Image(systemName: "cloud.bolt")
        case "22.0":
            return Image(systemName: "cloud.sleet")
        case "23.0":
            return Image(systemName: "cloud.sleet")
        case "24.0":
            return Image(systemName: "cloud.sleet.fill")
        case "25.0":
            return Image(systemName: "cloud.snow")
        case "26.0":
            return Image(systemName: "cloud.snow")
        case "27.0":
            return Image(systemName: "cloud.snow.fill")
        default:
            return Image(systemName: "cloud.fill")
        }
    }

}

struct WeatherView: View {

    @StateObject var theViewModel = ViewModel_WeatherApp()
    let symbolManager = WeatherSymbolManager()
    
    var body: some View {
        //VStack {
        //    ForEach(theViewModel.weatherDays) { day in
        //        VStack {
        //            Text(day.date ?? "no value")
        //            HStack {
        //                symbolManager.getWeatherImage(forWsymb2: day.Wsymb2)
        //                                                .font(.largeTitle)
        //                Text("\(day.temp)°C").font(.title).bold()
        //            }
        //            .padding()
        //            Spacer()
        //        }
        //    }
        //}
        Text("e")
    }
}


struct WeatherView_Previews : PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

