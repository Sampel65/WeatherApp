//
//  FavouriteCard.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 29/08/2025.
//


import SwiftUI


struct FavouriteCard: View {
    let favorite: FavoriteLocation
    var openAction: () -> Void
    var deleteAction: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Heart badge
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.ultraThinMaterial)
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
                    .font(.system(size: 18, weight: .semibold))
            }
            .frame(width: 36, height: 36)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.15)))

            // Title lines
            VStack(alignment: .leading, spacing: 2) {
                Text(favorite.primary)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                if let secondary = favorite.secondary, !secondary.isEmpty {
                    Text(secondary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Open (icon-only, gradient circle)
            Button(action: openAction) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.blue, .purple],
                                             startPoint: .topLeading,
                                             endPoint: .bottomTrailing))
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Open favourite")

            // Delete (ghost button)
            Button(role: .destructive, action: deleteAction) {
                Image(systemName: "trash")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.red)
                    .frame(width: 36, height: 36)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.15)))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove favourite")
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.15)))
        .contentShape(Rectangle())
        .onTapGesture { openAction() }
        .contextMenu {
            Button { openAction() } label: { Label("Open", systemImage: "arrow.forward.circle") }
            Button(role: .destructive) { deleteAction() } label: { Label("Remove", systemImage: "trash") }
        }
    }
}

struct HeartToggle: View {
    var isOn: Bool
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()

        }) {
            Image(systemName: isOn ? "heart.fill" : "heart")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(isOn ? .pink : .secondary)
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
                .overlay(Circle().stroke(.white.opacity(0.15)))
                .scaleEffect(isOn ? 1.08 : 1.0)
                .shadow(color: isOn ? Color.pink.opacity(0.25) : Color.clear, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isOn)
    }
}
