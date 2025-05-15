//
//  MockAPIService.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 15/05/2025.
//
@testable import Shoppy

class MockAPIService: APIServiceProtocol {
    var mockProducts: [Product] = []
    
    func request<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T {
            return mockProducts as! T
    }
}
