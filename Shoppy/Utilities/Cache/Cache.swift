//
//  Cache.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 14/05/2025.
//


protocol Cache<Object> {
    associatedtype Object: Codable
    func save(_ object: Object, forKey key: String)
    func load(forKey key: String) -> Object?
    func remove(forKey key: String)
}
