//
//  ProductCollectionViewCell.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ProductCollectionViewCell"

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(product: Product, isGrid: Bool) {
        title.text = product.title
        price.text = "\(product.price)$"
        mainStack.axis = isGrid ? .vertical : .horizontal
        mainStack.setNeedsLayout()
        mainStack.layoutIfNeeded()
    }
    
}
