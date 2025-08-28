//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var coordinator = AppCoordinator(container: AppContainer.default)

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.rootView()
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.destinationView(for: route)
                    }
            }
            .environmentObject(coordinator)
        }
    }
}
