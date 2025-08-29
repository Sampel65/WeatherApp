//
//  WeatherServiceProtocol.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> Weather
    func fetchWeather(lat: Double, lon: Double) async throws -> Weather
}


