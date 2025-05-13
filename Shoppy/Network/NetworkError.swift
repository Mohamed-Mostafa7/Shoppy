//
//  NetworkError.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//


enum NetworkError: Error {
    case invalidURL
    case noInternet
    case unauthorized
    case serverError
    case httpError(code: Int)
    case decoding(DecodingError)
    case other(Error)
    case unknown
}
