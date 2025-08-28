//
//  FavoriteCityStoreProtocol.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation

protocol FavoriteCityStoreProtocol {
    func loadFavoriteCity() -> String?
    func saveFavoriteCity(_ name: String)
    func clearFavoriteCity()
}

final class FavoriteCityStore: FavoriteCityStoreProtocol {
    private let key = "favorite_city_name"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadFavoriteCity() -> String? {
        defaults.string(forKey: key)
    }

    func saveFavoriteCity(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        defaults.set(trimmed, forKey: key)
    }

    func clearFavoriteCity() {
        defaults.removeObject(forKey: key)
    }
}