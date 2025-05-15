//
//  ImageLoader.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 14/05/2025.
//
import UIKit

protocol ImageLoader {
    func loadImage(from url: URL?, into imageView: UIImageView, placeholder: UIImage?)
}
