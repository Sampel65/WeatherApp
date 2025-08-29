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
    // Input
    @Published var city: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var alert: AppAlert?
    @Published var suggestions: [PlaceSuggestion] = []
    @Published var isSuggesting: Bool = false
    @Published var favorites: [FavoriteLocation] = []

    private let weatherService: WeatherServiceProtocol
    private let geocodingService: GeocodingServiceProtocol?
    private let favoriteStore: FavoriteCityStoreProtocol

    private var suggestTask: Task<Void, Never>?
    private var selectedSuggestion: PlaceSuggestion?

    init(weatherService: WeatherServiceProtocol,
         geocodingService: GeocodingServiceProtocol? = nil,
         favoriteStore: FavoriteCityStoreProtocol) {
        self.weatherService = weatherService
        self.geocodingService = geocodingService
        self.favoriteStore = favoriteStore

        self.favorites = favoriteStore.loadFavorites()
        if let first = favorites.first {
            self.city = first.displayLine
        }
    }
    
    // MARK: - Weather
    func fetchWeather() async -> Weather? {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            if let sel = selectedSuggestion {
                let weather = try await weatherService.fetchWeather(lat: sel.lat, lon: sel.lon)
                return weather
            } else {
                let weather = try await weatherService.fetchWeather(for: city)
                return weather
            }
        } catch {
            let message = userFriendlyMessage(from: error)
            errorMessage = message
            alert = AppAlert(title: "Unable to fetch weather", message: message)
            return nil
        }
    }

    func fetchWeather(for suggestion: PlaceSuggestion) async -> Weather? {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let weather = try await weatherService.fetchWeather(lat: suggestion.lat, lon: suggestion.lon)
            return weather
        } catch {
            let message = userFriendlyMessage(from: error)
            errorMessage = message
            alert = AppAlert(title: "Unable to fetch weather", message: message)
            return nil
        }
    }

    func fetchWeather(favorite: FavoriteLocation) async -> Weather? {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            if let lat = favorite.lat, let lon = favorite.lon {
                let weather = try await weatherService.fetchWeather(lat: lat, lon: lon)
                return weather
            } else {
                let weather = try await weatherService.fetchWeather(for: favorite.displayLine)
                return weather
            }
        } catch {
            let message = userFriendlyMessage(from: error)
            errorMessage = message
            alert = AppAlert(title: "Unable to fetch weather", message: message)
            return nil
        }
    }


    // MARK: - Suggestions (optional)
    func cityTextDidChange(_ newValue: String) {
        selectedSuggestion = nil
        suggestTask?.cancel()

        let q = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard q.count >= 2, let geocoder = geocodingService else {
            suggestions = []
            isSuggesting = false
            return
        }

        suggestTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 350_000_000)
            guard let self, !Task.isCancelled else { return }
            self.isSuggesting = true
            do {
                let results = try await geocoder.autocomplete(query: q, limit: 6)
                self.suggestions = Array(Set(results)).sorted { $0.name < $1.name }
            } catch {
                self.suggestions = []
            }
            self.isSuggesting = false
        }
    }

    func selectSuggestion(_ suggestion: PlaceSuggestion) {
        selectedSuggestion = suggestion
        city = suggestion.name + ", " + (suggestion.state ?? "") + (suggestion.state != nil ? ", " : "") + (Locale.current.localizedString(forRegionCode: suggestion.country) ?? suggestion.country)
        suggestions = []
        isSuggesting = false
    }

    // MARK: - Favourites
    var favoriteLimit: Int { favoriteStore.maxFavorites }

    var isCurrentCityFavorite: Bool {
        matchIndexForCurrentCity() != nil
    }

    func toggleFavoriteTapped() async {
        if let idx = matchIndexForCurrentCity() {
            favorites.remove(at: idx)
            favoriteStore.saveFavorites(favorites)
            return
        }
        await addFavoriteFromCurrent()
    }

    func removeFavorite(_ id: UUID) {
        favorites.removeAll { $0.id == id }
        favoriteStore.saveFavorites(favorites)
    }

    func addFavoriteFromCurrent() async {
        if favorites.count >= favoriteLimit {
            alert = AppAlert(title: "Limit reached", message: "You can save up to " + String(favoriteLimit) + " favourites.")
            return
        }

        // Prefer exact selected suggestion
        if let sel = selectedSuggestion {
            let fav = FavoriteLocation.fromSuggestion(sel)
            if !containsEquivalent(fav) {
                favorites.insert(fav, at: 0)
                favoriteStore.saveFavorites(favorites)
            }
            return
        }

        // Try geocoding current text
        let trimmed = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if let geocoder = geocodingService {
            do {
                if let first = try await geocoder.autocomplete(query: trimmed, limit: 1).first {
                    let fav = FavoriteLocation.fromSuggestion(first)
                    if !containsEquivalent(fav) {
                        favorites.insert(fav, at: 0)
                        favoriteStore.saveFavorites(favorites)
                    }
                    return
                }
            } catch {

            }
        }

        // Fallback: free text favourite
        let free = FavoriteLocation.fromFreeText(trimmed)
        if !containsEquivalent(free) {
            favorites.insert(free, at: 0)
            favoriteStore.saveFavorites(favorites)
        }
    }

    private func containsEquivalent(_ newFav: FavoriteLocation) -> Bool {
        favorites.contains(where: { eq($0, newFav) })
    }

    private func eq(_ a: FavoriteLocation, _ b: FavoriteLocation) -> Bool {
        if let alat = a.lat, let alon = a.lon, let blat = b.lat, let blon = b.lon {
            return abs(alat - blat) < 0.0001 && abs(alon - blon) < 0.0001
        }
        let aLine = a.displayLine.lowercased().replacingOccurrences(of: " ", with: "")
        let bLine = b.displayLine.lowercased().replacingOccurrences(of: " ", with: "")
        return aLine == bLine
    }

    private func matchIndexForCurrentCity() -> Int? {
        let current = city.lowercased().replacingOccurrences(of: " ", with: "")
        return favorites.firstIndex(where: { fav in
            fav.displayLine.lowercased().replacingOccurrences(of: " ", with: "") == current
            || fav.name.lowercased().replacingOccurrences(of: " ", with: "") == current
        })
    }


    // MARK: - Error formatting
    private func userFriendlyMessage(from error: Error) -> String {
        if let httpError = error as? HTTPError {
            switch httpError {
            case .badStatus(let code, let raw):
                let server = extractServerMessage(raw)
                if code == 404 {
                    return server ?? "City not found. Try a different name or include country code (e.g., \"Sydney, AU\")."
                } else {
                    return "Server error " + String(code) + (server != nil ? ": " + server! : "")
                }
            case .requestFailed(let underlying):
                return "Network error: " + underlying.localizedDescription
            case .decodingFailed:
                return "Could not read server response."
            case .invalidURL:
                return "Please enter a valid city name."
            case .noData:
                return "No data received from server."
            }
        }
        return error.localizedDescription
    }

    private func extractServerMessage(_ raw: String?) -> String? {
        guard let raw, let data = raw.data(using: .utf8) else { return nil }
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let msg = json["message"] as? String {
            return msg
        }
        return raw
    }
}
