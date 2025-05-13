//
//  HTTPMethod.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // Add more as needed
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?
    let headers: [String: String]?

    var url: URL? {
        var components = URLComponents(string: "https://fakestoreapi.com")
        components?.path += path
        components?.queryItems = queryItems
        return components?.url
    }
}
