//
//  SplashView.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                Text("Weatherly")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                coordinator.setRoot(.home)
            }
        }
        .accessibilityIdentifier("SplashView")
    }
}
