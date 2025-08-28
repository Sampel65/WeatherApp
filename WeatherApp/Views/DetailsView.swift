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
        VStack(spacing: 16) {
            Text(viewModel.weather.cityName)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(viewModel.temperatureString)
                    .font(.system(size: 56, weight: .semibold))
                Text(viewModel.weather.description)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(viewModel.detailSummary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { coordinator.pop() }) {
                    Label("Back", systemImage: "chevron.left")
                }
            }
        }
    }
}