//
//  DetailsViewModel.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation

final class DetailsViewModel: ObservableObject {
    let weather: Weather

    init(weather: Weather) {
        self.weather = weather
    }

    var temperatureString: String {
        String(format: "%.0f°C", weather.temperature)
    }

}
