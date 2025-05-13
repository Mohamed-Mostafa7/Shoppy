//
//  ProductListViewModel.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//


import Foundation

@MainActor
class ProductListViewModel {
    private let apiService: APIServiceProtocol
    private var allProducts: [Product] = []
    @Published var displayedProducts: [Product] = []
    private var currentOffset = 0
    private let limit = 7

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func loadProducts() async {
        do {
            let products: [Product] = try await apiService.request(
                endpoint: .allProducts(),
                responseModel: [Product].self
            )
            print("success")
            for product in products {
                print(product.id)
                print(product.title)
            }
            allProducts = products
            loadMore()
        } catch {
            print("Error fetching products: \(error)")
        }
    }

    func loadMore() {
        guard currentOffset < allProducts.count else { return }
        let nextBatch = allProducts[currentOffset..<min(currentOffset + limit, allProducts.count)]
        displayedProducts.append(contentsOf: nextBatch)
        currentOffset += limit
    }
}
