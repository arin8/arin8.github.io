//
//  StatisticView.swift
//  WorkoutDiary
//
//  Created by Arin Rahim on 2024-01-06.
//

import SwiftUI
import Charts

struct StatisticView: View {
    
    @StateObject var statsViewModel = StatsViewModel()
    let stats = StatsData.setsExample
    let pieStats = PieChartMuscleGroup.muscleGroups
    
    var body: some View
    {
        NavigationView
        {
            ScrollView
            {
                VStack
                {
                    Text("OCT 2023 - 19 workouts").position(x: 105, y: 15)
                    Chart
                    {
                        ForEach(stats)
                        { data in
                            BarMark(x: .value("", data.day),
                                    y: .value("Sets", data.sets))
                            .foregroundStyle(Color.white.opacity(0.5))
                        }
                        
                        RuleMark(y: .value("Average", 11))
                            .foregroundStyle(Color.black)
                            .annotation(position: .top, alignment: .bottomLeading)
                        {
                            Text("Average sets: 11")
                        }
                    }
                    .frame(height: 200)
                    .foregroundColor(.white)
                    .chartXScale(domain: [1, 33])
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                    Text("Total sets: 218").position(x: 65, y: 0).bold()
                    
                    Chart
                    {
                        ForEach(stats)
                        { data in
                            BarMark(x: .value("", data.day),
                                    y: .value("Reps", data.reps))
                            .foregroundStyle(Color.white.opacity(0.5))
                        }
                        RuleMark(y: .value("Average", 93))
                            .foregroundStyle(Color.black)
                            .annotation(position: .top, alignment: .bottomLeading)
                        {
                            Text("Average reps: 93")
                        }
                    }
                    .frame(height: 200)
                    .foregroundStyle(.white)
                    .chartXScale(domain: [1, 33])
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                    Text("Total reps: 1759").position(x: 70, y: 0).bold()
                    
                    Chart
                    {
                        ForEach(pieStats)
                        { data in
                            SectorMark(angle: .value(data.muscleGroup, data.precantage), innerRadius: .ratio(0.5), angularInset: 1)
                                .foregroundStyle(by: .value("", data.muscleGroup))
                                .annotation(position: .overlay) {
                                    Text("\(Int(data.precantage))%")
                                        .bold()
                                        .foregroundColor(.white)
                                }
                        }
                        
                    }
                    .chartLegend(.visible)
                    .frame(height: 200)
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                }
            }.navigationTitle("Statistics")
                .background(LinearGradient(colors: [.green, .blue], startPoint: .top, endPoint: .bottom))
        }
    }
}

#Preview {
    StatisticView()
}
