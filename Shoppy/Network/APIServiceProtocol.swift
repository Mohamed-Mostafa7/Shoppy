//
//  APIServiceProtocol.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//


protocol APIServiceProtocol {
    func request<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async throws -> T
}
