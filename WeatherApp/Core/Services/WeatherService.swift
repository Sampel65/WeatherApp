//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 29/08/2025.
//

import Foundation

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
        guard !city.isEmpty else { throw HTTPError.invalidURL }

        var comps = URLComponents(url: baseURL.appendingPathComponent("weather"), resolvingAgainstBaseURL: false)
        comps?.queryItems = [
            .init(name: "q", value: city),
            .init(name: "appid", value: apiKey),
            .init(name: "units", value: "metric")
        ]
        guard let url = comps?.url else { throw HTTPError.invalidURL }
        let dto: WeatherResponse = try await network.request(URLRequest(url: url))
        return dto.toDomain()
    }

    // NEW: precise lookup by coordinates from suggestion
    func fetchWeather(lat: Double, lon: Double) async throws -> Weather {
        var comps = URLComponents(url: baseURL.appendingPathComponent("weather"), resolvingAgainstBaseURL: false)
        comps?.queryItems = [
            .init(name: "lat", value: String(lat)),
            .init(name: "lon", value: String(lon)),
            .init(name: "appid", value: apiKey),
            .init(name: "units", value: "metric")
        ]
        guard let url = comps?.url else { throw HTTPError.invalidURL }
        let dto: WeatherResponse = try await network.request(URLRequest(url: url))
        return dto.toDomain()
    }
}
