//
//  ProductsViewController.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//

import UIKit
import Combine

class ProductsViewController: UIViewController {
    
    let viewModel: ProductListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ProductsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        
        bindViewModel()
        Task {
            await viewModel.loadProducts()
        }
    }
    
    private func bindViewModel() {
        viewModel.$displayedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print(self?.viewModel.displayedProducts ?? "no products")
            }
            .store(in: &cancellables)
    }
    
}
