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
    private let cache: any Cache<[Product]>
    
    @Published var displayedProducts: [Product] = []
    @Published var isGridLayout = true
    @Published var isLoading = false
    @Published var noInternet = false
    
    private var currentOffset = 1
    private let limit = 7
    var allProductLoaded = false

    init(apiService: APIServiceProtocol, coordinator: ProductCoordinator, cache: any Cache<[Product]> = UserDefaultsCache<[Product]>()) {
        self.apiService = apiService
        self.coordinator = coordinator
        self.cache = cache
    }
    
    func pushToDetailsView(product: Product) {
        coordinator.showProductDetails(for: product)
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

// MARK: - Networking

extension ProductListViewModel {

     func loadProducts(limit: Int) async {
        do {
            let products: [Product] = try await apiService.request(
                endpoint: .allProducts(limit: limit),
                responseModel: [Product].self
            )
            currentOffset += 1
            /// if the displayed products equal the fetched products that means that we reached the end of the products and there is no more products.
            /// so we disable loading more funcion for better user experience.
            if displayedProducts.count == products.count, products.count != 7 {
                allProductLoaded = true
            } else {
                displayedProducts = products
                saveProductsIntoCache()
            }
        }catch let error as NetworkError {
            handleNetworkError(error)
        }catch {
            print("Error fetching products: \(error)")
        }
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        switch error {
        case .invalidURL:
            print("Invalid URL. Please check the endpoint.")
        case .noInternet:
            // MARK: - show the cashed data
            noInternet = true
            print("No internet connection. Please try again later.")
        case .unauthorized:
            print("Unauthorized access. Please log in again.")
        case .serverError:
            print("Server error occurred. Please try again later.")
        case .httpError(let code):
            print("HTTP Error with code: \(code)")
        case .decoding(let decodingError):
            print("Decoding error: \(decodingError)")
        case .other(let err):
            print("Unexpected error: \(err.localizedDescription)")
        case .unknown:
            print("An unknown error occurred.")
        }
    }
}

// MARK: - Cache handling

extension ProductListViewModel {
    func loadProductsFromCache() {
        if let cachedProducts = cache.load(forKey: "products") {
            displayedProducts = cachedProducts
        }
    }
    
    func saveProductsIntoCache() {
        guard displayedProducts.count != 0 else { return }
        if displayedProducts.count >= 7 {
            let firstSevenProducts = Array(displayedProducts.prefix(7))
            cache.save(firstSevenProducts, forKey: "products")
        } else {
            cache.save(displayedProducts, forKey: "products")
        }
    }
}
