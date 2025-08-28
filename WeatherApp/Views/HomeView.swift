//
//  HomeView.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import SwiftUI
import Foundation

struct HomeView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject var viewModel: HomeViewModel

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text("Check the weather")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                TextField("Enter city (e.g. London)", text: $viewModel.city)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .submitLabel(.search)
                    .focused($isTextFieldFocused)
                    .onSubmit { Task { await search() } }

                Button {
                    Task { await search() }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .padding(10)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Search")
            }

            HStack(spacing: 8) {
                Button {
                    viewModel.saveAsFavorite()
                } label: {
                    Label("Save as favourite", systemImage: "star")
                }
                .buttonStyle(.bordered)

                Button(role: .destructive) {
                    viewModel.clearFavorite()
                } label: {
                    Label("Clear favourite", systemImage: "trash")
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier("HomeErrorLabel")
            }

            Spacer()
        }
        .padding()
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView("Loading...")
                        .padding(24)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .navigationTitle("Home")
        .onAppear {
            // Demonstrate lifecycle: pre-population happens in VM init
        }
    }

    private func search() async {
        isTextFieldFocused = false
        if let weather = await viewModel.fetchWeather() {
            coordinator.push(.details(weather))
        }
    }
}
