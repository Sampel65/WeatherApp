//
//  AppContainer.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//

import Foundation
import Foundation

struct AppContainer {
    let network: Networking
    let weatherService: WeatherServiceProtocol
    let favoriteCityStore: FavoriteCityStoreProtocol

    static var `default`: AppContainer {
        let network = NetworkManager()
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENWEATHER_API_KEY") as? String ?? ""
        assert(!apiKey.isEmpty, "OPENWEATHER_API_KEY is missing from Info.plist")
        let weatherService = WeatherService(network: network, apiKey: apiKey)
        let favorite = FavoriteCityStore()
        return AppContainer(network: network, weatherService: weatherService, favoriteCityStore: favorite)
    }
}
