//
//  FavoriteLocation.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 29/08/2025.
//


import Foundation

struct FavoriteLocation: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let state: String?
    let country: String
    let lat: Double?
    let lon: Double?
    let createdAt: Date

    var primary: String { name }

    var secondary: String? {
        let region = Locale.current.localizedString(forRegionCode: country) ?? country
        if let s = state, !s.isEmpty { return s + ", " + region }
        return region
    }

    var displayLine: String {
        let region = Locale.current.localizedString(forRegionCode: country) ?? country
        if let s = state, !s.isEmpty { return name + ", " + s + ", " + region }
        return name + ", " + region
    }

    static func fromSuggestion(_ s: PlaceSuggestion) -> FavoriteLocation {
        FavoriteLocation(id: UUID(), name: s.name, state: s.state, country: s.country, lat: s.lat, lon: s.lon, createdAt: Date())
    }

    static func fromFreeText(_ text: String) -> FavoriteLocation {
        FavoriteLocation(id: UUID(), name: text, state: nil, country: "", lat: nil, lon: nil, createdAt: Date())
    }
}