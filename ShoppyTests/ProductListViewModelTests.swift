//
//  ProductListViewModelTests.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 15/05/2025.
//
import XCTest
@testable import Shoppy

final class ProductListViewModelTests: XCTestCase {
    
    // MARK: - Test: Load Data Success
    
    func test_loadData_whenSuccessful_shouldDisplayOnlySevenProductsAndNotSetFlags() async {
        // Given
        let mockProducts = (1...7).map {
            Product(
                id: $0,
                title: "Product \($0)",
                price: 99.0,
                description: "Description \($0)",
                category: "Category",
                image: "",
                rating: .init(rate: 4.5, count: 10)
            )
        }
        let viewModel = await makeSUT(products: mockProducts)

        // When
        await viewModel.loadProducts(limit: 7)

        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.displayedProducts.count, 7, "Expected 7 products (due to hardcoded limit), but got \(viewModel.displayedProducts.count)")
            XCTAssertEqual(viewModel.displayedProducts.first?.title, "Product 1")
            XCTAssertFalse(viewModel.isLoading, "Expected isLoading to be false after load completes")
        }
    }

    // MARK: - Helpers
    
    @MainActor private func makeSUT(products: [Product]) async -> ProductListViewModel {
        let mockService = MockAPIService()
        mockService.mockProducts = products
        let mockCache = MockCache<[Product]>()
        let coordinator = await MainActor.run {
                MockCoordinator(navigationController: UINavigationController())
            }
        return ProductListViewModel(apiService: mockService, coordinator: coordinator, cache: mockCache)
    }
}


