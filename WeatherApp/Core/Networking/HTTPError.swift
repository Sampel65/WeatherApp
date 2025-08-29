//
//  HTTPError.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation


enum HTTPError: LocalizedError {
    case invalidURL
    case requestFailed(underlying: Error)
    case badStatus(code: Int, message: String?)
    case decodingFailed(underlying: Error)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let err):
            return "Request failed: \(err.localizedDescription)"
        case .badStatus(let code, let message):
            return "HTTP \(code): \(message ?? "Unexpected server response.")"
        case .decodingFailed(let err):
            return "Decoding failed: \(err.localizedDescription)"
        case .noData:
            return "No data received"
        }
    }
}

// Manual Equatable conformance (ignore underlying Error equality)
extension HTTPError: Equatable {
    static func == (lhs: HTTPError, rhs: HTTPError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case (.noData, .noData): return true
        case (.requestFailed, .requestFailed): return true
        case (.decodingFailed, .decodingFailed): return true
        case (.badStatus(let lc, _), .badStatus(let rc, _)): return lc == rc
        default: return false
        }
    }
}