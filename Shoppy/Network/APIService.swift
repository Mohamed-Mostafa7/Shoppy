//
//  APIService.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//
import Foundation

final class APIService: APIServiceProtocol {
    private let urlSession: URLSession
    private let reachability: NetworkReachabilityChecking

    init(
        urlSession: URLSession = .shared,
        reachability: NetworkReachabilityChecking = NetworkReachability()
    ) {
        self.urlSession = urlSession
        self.reachability = reachability
    }

    func request<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        guard reachability.isConnected else {
            throw NetworkError.noInternet
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        do {
            let (data, response) = try await urlSession.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }

            switch httpResponse.statusCode {
            case 200...299:
                return try JSONDecoder().decode(T.self, from: data)
            case 401:
                throw NetworkError.unauthorized
            case 500...599:
                throw NetworkError.serverError
            default:
                throw NetworkError.httpError(code: httpResponse.statusCode)
            }
        } catch let decodingError as DecodingError {
            throw NetworkError.decoding(decodingError)
        } catch {
            throw NetworkError.other(error)
        }
    }
}
