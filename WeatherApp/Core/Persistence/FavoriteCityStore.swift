//
//  FavoriteCityStore.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 29/08/2025.
//

import Foundation

final class FavoriteCityStore: FavoriteCityStoreProtocol {
    let maxFavorites: Int = 3

    private let key = "favorite_locations_v2"
    private let legacyKey = "favorite_city_name" 
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        migrateIfNeeded()
    }

    func loadFavorites() -> [FavoriteLocation] {
        guard let data = defaults.data(forKey: key) else { return [] }
        do { return try JSONDecoder().decode([FavoriteLocation].self, from: data) }
        catch { return [] }
    }

    func saveFavorites(_ items: [FavoriteLocation]) {
        let trimmed = Array(items.prefix(maxFavorites))
        if let data = try? JSONEncoder().encode(trimmed) {
            defaults.set(data, forKey: key)
        }
    }

    private func migrateIfNeeded() {
        guard defaults.data(forKey: key) == nil else { return }
        if let single = defaults.string(forKey: legacyKey), !single.isEmpty {
            let fav = FavoriteLocation.fromFreeText(single)
            saveFavorites([fav])
            defaults.removeObject(forKey: legacyKey)
        }
    }
}
