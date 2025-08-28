//
//  Networking.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//


import Foundation

protocol Networking {
    func request<T: Decodable>(_ request: URLRequest) async throws -> T
}

final class NetworkManager: Networking {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw HTTPError.requestFailed(underlying: URLError(.badServerResponse))
            }

            guard (200..<300).contains(http.statusCode) else {
                let serverMessage = String(data: data, encoding: .utf8)
                throw HTTPError.badStatus(code: http.statusCode, message: serverMessage)
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw HTTPError.decodingFailed(underlying: error)
            }
        } catch {
            if let httpError = error as? HTTPError { throw httpError }
            throw HTTPError.requestFailed(underlying: error)
        }
    }
}