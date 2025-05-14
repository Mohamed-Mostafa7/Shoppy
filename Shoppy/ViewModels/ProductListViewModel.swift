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
    private let coordinator: ProductCoordinator
    
    @Published var displayedProducts: [Product] = []
    @Published var isGridLayout = true
    @Published var isLoading = false
    
    private var currentOffset = 1
    private let limit = 7
    var allProductLoaded = false

    init(apiService: APIServiceProtocol, coordinator: ProductCoordinator) {
        self.apiService = apiService
        self.coordinator = coordinator
    }
    
    func pushToDetailsView(product: Product) {
        coordinator.showProductDetails(for: product)
    }

    private func loadProducts(limit: Int) async {
        print("all product loaded: \(allProductLoaded)")
        do {
            let products: [Product] = try await apiService.request(
                endpoint: .allProducts(limit: limit),
                responseModel: [Product].self
            )
            currentOffset += 1
            /// if the displayed products equal the fetched products that means that we reached the end of the products and there is no more products.
            /// so we disable loading more funcion for better user experience.
            if displayedProducts.count == products.count {
                allProductLoaded = true
            } else {
                displayedProducts = products
            }
        } catch {
            print("Error fetching products: \(error)")
        }
    }

    // MARK: - Data
     func loadData() {
        Task {
            isLoading = true
            await loadProducts(limit: limit)
            isLoading = false
        }
    }
    
    func loadMore() {
        let newLimit = limit * currentOffset
        Task {
            isLoading = true
            await loadProducts(limit: newLimit)
            isLoading = false
        }
    }
}
