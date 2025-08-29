//
//  AppContainer.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation

struct AppContainer {
    let network: Networking
    let weatherService: WeatherServiceProtocol
    let geocodingService: GeocodingServiceProtocol 
    let favoriteCityStore: FavoriteCityStoreProtocol

    static var `default`: AppContainer {
        let network = NetworkManager()
        let apiKey = "7a134eb57b6e20ac51ab9d92d3a802e1"
        let weatherService = WeatherService(network: network, apiKey: apiKey)
        let geocoding = GeocodingService(network: network, apiKey: apiKey)  
        let favorite = FavoriteCityStore()
        return AppContainer(
            network: network,
            weatherService: weatherService,
            geocodingService: geocoding,
            favoriteCityStore: favorite
        )
    }
}

extension Data {
    var prettyJSONString: String? {
        if let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString
        }
        return String(data: self, encoding: .utf8)
    }
}
