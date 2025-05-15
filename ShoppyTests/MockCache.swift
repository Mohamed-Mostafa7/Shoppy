//
//  MockCache.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 15/05/2025.
//
@testable import Shoppy

class MockCache<T: Codable>: Cache {
    typealias Object = T
    
    func remove(forKey key: String) {
        
    }
    
    var store: [String: T] = [:]
    
    func save(_ object: T, forKey key: String) {
        store[key] = object
    }
    
    func load(forKey key: String) -> T? {
        return store[key]
    }
}
