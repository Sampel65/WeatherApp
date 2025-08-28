//
//  Weather.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation

struct Weather: Hashable {
    let cityName: String
    let description: String
    let temperature: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    let humidity: Int
    let icon: String?
}