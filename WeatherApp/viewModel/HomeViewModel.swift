//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let weatherService: WeatherServiceProtocol
    private let favoriteStore: FavoriteCityStoreProtocol

    init(weatherService: WeatherServiceProtocol, favoriteStore: FavoriteCityStoreProtocol) {
        self.weatherService = weatherService
        self.favoriteStore = favoriteStore
        if let fav = favoriteStore.loadFavoriteCity() {
            self.city = fav
        }
    }

    func fetchWeather() async -> Weather? {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let weather = try await weatherService.fetchWeather(for: city)
            return weather
        } catch {
            if let httpError = error as? HTTPError {
                errorMessage = httpError.localizedDescription
            } else {
                errorMessage = error.localizedDescription
            }
            return nil
        }
    }

    func saveAsFavorite() {
        favoriteStore.saveFavoriteCity(city)
    }

    func clearFavorite() {
        favoriteStore.clearFavoriteCity()
    }
}
