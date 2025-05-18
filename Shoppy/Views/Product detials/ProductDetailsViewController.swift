//
//  ProductDetailsViewController.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 14/05/2025.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    private let viewModel: ProductDetailsViewModel
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productRating: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    
    // MARK: - Init
    init(viewModel: ProductDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ProductDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setUpUI()
    }
    
    // MARK: - setupUI
    func setUpUI() {
        if let imageURL = URL(string: viewModel.product.image) {
            let placeholder = UIImage(named: "placeholder")
            viewModel.imageLoader?.loadImage(from: imageURL, into: productImage, placeholder: placeholder)
        }
        productTitle.text = viewModel.product.title
        productPrice.text = "\(viewModel.product.price)$"
        productRating.text = "\(viewModel.product.rating.rate) ⭐️"
        productDescription.text = viewModel.product.description
    }

}

// MARK: - UIScrollViewDelegate
extension ProductDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let imageHeight = productImage.frame.height
        if offsetY < 0 {
            productImage.transform = CGAffineTransform(translationX: 0, y: offsetY)
                .scaledBy(x: 1 + abs(offsetY) / imageHeight, y: 1 + abs(offsetY) / imageHeight)
        } else {
            productImage.transform = .identity
        }
    }
}
