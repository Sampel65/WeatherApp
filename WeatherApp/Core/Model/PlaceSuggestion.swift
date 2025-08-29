//
//  PlaceSuggestion.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation

// MARK: - Domain
struct PlaceSuggestion: Identifiable, Hashable {
    var id: String { name + "|" + (state ?? "") + "|" + country + "|" + String(lat) + "|" + String(lon) }

    let name: String
    let state: String?
    let country: String
    let lat: Double
    let lon: Double

    var countryDisplay: String {
        Locale.current.localizedString(forRegionCode: country) ?? country
    }

    var primaryText: String { name }
    var secondaryText: String {
        if let state = state, !state.isEmpty {
            return state + ", " + countryDisplay
        }
        return countryDisplay
    }

    var fullLine: String {
        if let state = state, !state.isEmpty {
            return name + ", " + state + ", " + countryDisplay
        }
        return name + ", " + countryDisplay
    }
}

// MARK: - DTO
private struct GeocodingPlaceDTO: Decodable {
    let name: String
    let local_names: [String: String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    func toDomain() -> PlaceSuggestion {
        PlaceSuggestion(name: name, state: state, country: country, lat: lat, lon: lon)
    }
}

// MARK: - Protocol
protocol GeocodingServiceProtocol {
    func autocomplete(query: String, limit: Int) async throws -> [PlaceSuggestion]
}

// MARK: - Impl
final class GeocodingService: GeocodingServiceProtocol {
    private let network: Networking
    private let apiKey: String
    private let baseURL = URL(string: "https://api.openweathermap.org/geo/1.0")!

    init(network: Networking, apiKey: String) {
        self.network = network
        self.apiKey = apiKey
    }

    func autocomplete(query: String, limit: Int = 6) async throws -> [PlaceSuggestion] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        var components = URLComponents(url: baseURL.appendingPathComponent("direct"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            .init(name: "q", value: trimmed),
            .init(name: "limit", value: String(limit)),
            .init(name: "appid", value: apiKey)
        ]
        guard let url = components?.url else { throw HTTPError.invalidURL }

        let req = URLRequest(url: url)
        let dto: [GeocodingPlaceDTO] = try await network.request(req)
        return dto.map { $0.toDomain() }
    }
}
