//
//  KingfisherImageLoader.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 14/05/2025.
//

import UIKit
import Kingfisher

class KingfisherImageLoader: @preconcurrency ImageLoader {
    @MainActor func loadImage(from url: URL?, into imageView: UIImageView, placeholder: UIImage?) {
        
        let indicator = LargeActivityIndicator()
        indicator.frame = imageView.bounds
        imageView.kf.indicatorType = .custom(indicator: indicator)
        
        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ],
            completionHandler: { result in
                switch result {
                case .success(let value):
                    print("Image loaded: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Image loading failed: \(error)")
                }
            }
        )
    }
}

class LargeActivityIndicator: UIView, Indicator {
    var view: UIView { return self }

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .green
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func startAnimatingView() {
        isHidden = false
        activityIndicator.startAnimating()
    }

    func stopAnimatingView() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
