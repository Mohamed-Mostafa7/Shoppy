//
//  ProductDetailsViewModel.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 14/05/2025.
//

import Foundation

final class ProductDetailsViewModel {
    var product: Product
    let imageLoader: ImageLoader?
    
    init(product: Product, imageLoader: ImageLoader = KingfisherImageLoader()) {
        self.product = product
        self.imageLoader = imageLoader
    }
    
}
