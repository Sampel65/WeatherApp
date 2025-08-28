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

    var detailSummary: String {
        "Feels like KATEX_INLINE_OPENInt(weather.feelsLike))°C • H: KATEX_INLINE_OPENInt(weather.maxTemp))°C L: KATEX_INLINE_OPENInt(weather.minTemp))°C • Humidity: KATEX_INLINE_OPENweather.humidity)%"
    }
}