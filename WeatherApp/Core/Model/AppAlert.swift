//
//  AppAlert.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//
import Foundation

struct AppAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}
