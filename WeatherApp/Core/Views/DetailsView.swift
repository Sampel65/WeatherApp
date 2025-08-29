//
//  DetailsView.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import SwiftUI

struct DetailsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject var viewModel: DetailsViewModel

    var body: some View {
        ZStack {
            LinearGradient(colors: [.indigo, .blue],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {

                    // City + Icon
                    VStack(spacing: 16) {
                        Text(viewModel.weather.cityName)
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        if let icon = viewModel.weather.icon {
                            AsyncImage(
                                url: URL(string: "https://openweathermap.org/img/wn/" + icon + "@3x.png")
                            ) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                            } placeholder: {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                        }
                    }


                    VStack(spacing: 6) {
                        Text(viewModel.temperatureString)
                            .font(.system(size: 72, weight: .heavy))
                            .foregroundColor(.white)
                        Text(viewModel.weather.description)
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.85))
                    }

                    // Stats grid
                    VStack(spacing: 16) {
                        HStack {
                            statTile(system: "thermometer.medium", title: "Feels Like",
                                     value: String(Int(viewModel.weather.feelsLike)) + "°C")
                            statTile(system: "drop.fill", title: "Humidity",
                                     value: String(viewModel.weather.humidity) + "%")
                        }
                        HStack {
                            statTile(system: "arrow.down.circle", title: "Min Temp",
                                     value: String(Int(viewModel.weather.minTemp)) + "°C")
                            statTile(system: "arrow.up.circle", title: "Max Temp",
                                     value: String(Int(viewModel.weather.maxTemp)) + "°C")
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25))
                    .shadow(color: .black.opacity(0.3), radius: 10, y: 5)

                    Spacer()
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
            }
        }
    }

    @ViewBuilder
    private func statTile(system: String, title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: system)
                .foregroundColor(.blue)
                .font(.system(size: 28))
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 15))
    }
}
