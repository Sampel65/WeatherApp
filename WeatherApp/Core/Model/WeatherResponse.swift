//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation

struct WeatherResponse: Decodable {
    struct WeatherItem: Decodable {
        let description: String
        let icon: String
    }
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int
    }

    let weather: [WeatherItem]
    let main: Main
    let name: String

    func toDomain() -> Weather {
        Weather(
            cityName: name,
            description: weather.first?.description.capitalized ?? "N/A",
            temperature: main.temp,
            feelsLike: main.feels_like,
            minTemp: main.temp_min,
            maxTemp: main.temp_max,
            humidity: main.humidity,
            icon: weather.first?.icon
        )
    }
}