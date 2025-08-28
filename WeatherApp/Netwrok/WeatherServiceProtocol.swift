//
//  WeatherServiceProtocol.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> Weather
}

final class WeatherService: WeatherServiceProtocol {
    private let network: Networking
    private let apiKey: String
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!

    init(network: Networking, apiKey: String) {
        self.network = network
        self.apiKey = apiKey
    }

    func fetchWeather(for city: String) async throws -> Weather {
        let city = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !city.isEmpty else {
            throw HTTPError.invalidURL 
        }

        var components = URLComponents(url: baseURL.appendingPathComponent("weather"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            .init(name: "q", value: city),
            .init(name: "appid", value: apiKey),
            .init(name: "units", value: "metric")
        ]

        guard let url = components?.url else {
            throw HTTPError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let dto: WeatherResponse = try await network.request(request)
        return dto.toDomain()
    }
}
