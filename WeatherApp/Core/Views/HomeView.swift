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
        ZStack {
            // Gradient animated background
            LinearGradient(colors: [.blue.opacity(0.9), .purple.opacity(0.8)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                // App Title
                VStack(spacing: 8) {
                    Image(systemName: "cloud.sun.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.white)
                        .shadow(radius: 10)
                    
                    Text("Weatherly")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                }
                .padding(.top, 40)

                // Glass card for search

                VStack(spacing: 12) {
                    // Search row
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)

                        TextField("Enter city name…", text: $viewModel.city)
                            .focused($isTextFieldFocused)
                            .submitLabel(.search)
                            .onSubmit { Task { await search() } }
                            .onChange(of: viewModel.city) { newValue in
                                viewModel.cityTextDidChange(newValue)
                            }
                            .foregroundColor(.black)
                            .autocorrectionDisabled()

                        if !viewModel.city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Button {
                                viewModel.city = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.plain)
                        }

                        // Favourite toggle
                        HeartToggle(isOn: viewModel.isCurrentCityFavorite) {
                            Task { await viewModel.toggleFavoriteTapped() }
                        }
                        .disabled(viewModel.city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(viewModel.city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))

                    // Suggestion list
                    if viewModel.isSuggesting {
                        HStack(spacing: 8) {
                            ProgressView()
                            Text("Searching…")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                    }

                    if !viewModel.suggestions.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(viewModel.suggestions) { item in
                                Button {
                                    isTextFieldFocused = false
                                    viewModel.selectSuggestion(item)
 
                                    Task {
                                        if let weather = await viewModel.fetchWeather(for: item) {
                                            coordinator.push(.details(weather))
                                        }
                                    }
                                } label: {
                                    HStack(alignment: .firstTextBaseline) {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.primaryText)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Text(item.secondaryText)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                }
                                .buttonStyle(.plain)

                                if item.id != viewModel.suggestions.last?.id {
                                    Divider().opacity(0.35)
                                }
                            }
                        }
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.15))
                        )
                    }

                    // Favourite card
                    if !viewModel.favorites.isEmpty {
                        HStack {
                            Label("Favourites", systemImage: "")
                                .foregroundColor(.pink)
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Text(String(viewModel.favorites.count) + " / " + String(viewModel.favoriteLimit))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 4)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.favorites) { fav in
                                    FavouriteCard(
                                        favorite: fav,
                                        openAction: {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()

                                            Task {
                                                if let w = await viewModel.fetchWeather(favorite: fav) {
                                                    coordinator.push(.details(w))
                                                }
                                            }
                                        },
                                        deleteAction: {
                                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                            viewModel.removeFavorite(fav.id)
                                        }
                                    )
                                    .frame(width: 280)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 20)

                
                
                Spacer()

                // CTA Button
                Button {
                    Task { await search() }
                } label: {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.blue, .purple],
                                                 startPoint: .topLeading,
                                                 endPoint: .bottomTrailing))
                            .frame(width: 90, height: 90)
                            .shadow(color: .white.opacity(0.4), radius: 10)
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.bottom, 40)
                Spacer()
            }
            .padding()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Fetching weather...")
                    .padding(20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .alert(item: $viewModel.alert) { alert in
            Alert(title: Text(alert.title),
                  message: Text(alert.message),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private func search(suggestion: PlaceSuggestion? = nil) async {
        isTextFieldFocused = false
        let weather: Weather?
        if let s = suggestion {
            weather = await viewModel.fetchWeather(for: s)
        } else {
            weather = await viewModel.fetchWeather()
        }
        if let w = weather { coordinator.push(.details(w)) }
    }
}
