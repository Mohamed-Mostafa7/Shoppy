//
//  UserDefaultsCache.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 14/05/2025.
//
import Foundation

final class UserDefaultsCache<T: Codable>: Cache {
    typealias Object = T
    private let defaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    func save(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            defaults.set(data, forKey: key)
        } catch {
            print("Failed to save to UserDefaults: \(error)")
        }
    }

    func load(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Failed to decode from UserDefaults: \(error)")
            return nil
        }
    }

    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
