//
//  ProductsCoordinator.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//
import UIKit

final class ProductCoordinator: @preconcurrency Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    @MainActor func start() {
        let apiService = APIService()
        let viewModel = ProductListViewModel(apiService: apiService, coordinator: self)
        let productListVC = ProductsViewController(viewModel: viewModel)
        navigationController.pushViewController(productListVC, animated: true)
    }

    func showProductDetails(for product: Product) {
//        let detailsViewModel = ProductDetailsViewModel(product: product)
//        let detailsVC = ProductDetailsViewController(viewModel: detailsViewModel)
//        navigationController.pushViewController(detailsVC, animated: true)
    }
}
