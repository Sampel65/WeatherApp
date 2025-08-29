//
//  FavoriteCityStoreProtocol.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation

import Foundation

protocol FavoriteCityStoreProtocol {
    var maxFavorites: Int { get }
    func loadFavorites() -> [FavoriteLocation]
    func saveFavorites(_ items: [FavoriteLocation])
}

