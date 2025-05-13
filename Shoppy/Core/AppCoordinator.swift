//
//  Coordinator.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}


final class AppCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    @MainActor func start() {
        displayProductsCoordinator()
    }
}

extension AppCoordinator {
    @MainActor func displayProductsCoordinator() {
        let navigationController = UINavigationController()
        let coordinator = ProductCoordinator(navigationController: navigationController)
        coordinator.start()
        rootViewController(navigationController)
    }
    
    func rootViewController(_ viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
