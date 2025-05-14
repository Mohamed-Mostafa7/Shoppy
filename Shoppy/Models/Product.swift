//
//  Product.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//


import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}
