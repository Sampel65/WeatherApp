//
//  AppRoute.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import SwiftUI

enum AppRoute: Hashable {
    case splash
    case home
    case details(Weather)
}

 final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published private(set) var root: AppRoute = .splash

    let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    // Root view switcher
    @MainActor
    @ViewBuilder
    func rootView() -> some View {
        switch root {
        case .splash:
            SplashView()
        case .home:
            HomeView(viewModel: HomeViewModel(
                weatherService: self.container.weatherService,
                geocodingService: self.container.geocodingService,
                favoriteStore: self.container.favoriteCityStore
            ))
        case .details(let weather):
            DetailsView(viewModel: DetailsViewModel(weather: weather))
        }
    }

    @MainActor
    @ViewBuilder
    func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .details(let weather):
            DetailsView(viewModel: DetailsViewModel(weather: weather))
        case .home:
            HomeView(viewModel: HomeViewModel(
                weatherService: self.container.weatherService,
                geocodingService: self.container.geocodingService,
                favoriteStore: self.container.favoriteCityStore
            ))
        case .splash:
            SplashView()
        }
    }

    func setRoot(_ route: AppRoute) {
        path.removeAll()
        root = route
    }

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }
}
