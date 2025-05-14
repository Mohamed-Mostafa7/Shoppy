//
//  ProductsViewController.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//

import UIKit
import Combine

class ProductsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ProductListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Init
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ProductsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadProductsFromCache()
        viewModel.loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Products"
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: #selector(toggleLayout)
        )
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: ProductCollectionViewCell.reuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            UINib(nibName: LoadingFooterView.reuseIdentifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingFooterView.reuseIdentifier
        )
        
    }
    
    // MARK: - Actions
    @objc private func toggleLayout() {
        viewModel.isGridLayout.toggle()
        let iconName = viewModel.isGridLayout ? "list.bullet" : "square.grid.2x2"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: iconName)
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.$displayedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isGridLayout
            .receive(on: RunLoop.main)
            .sink { [weak self] isGrid in
                guard let self = self else { return }
                self.collectionView.setCollectionViewLayout(self.createLayout(isGrid: isGrid), animated: true)
                let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
                self.collectionView.reloadItems(at: visibleIndexPaths)
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadSections(IndexSet(integer: 0))
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Layout
    private func createLayout(isGrid: Bool) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 10
        let totalPadding: CGFloat = isGrid ? (padding * 3) : (padding * 2)
        let width = (view.frame.width - totalPadding) / (isGrid ? 2.2 : 1)
        let height = isGrid ? width * 1.2 : width / 3
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        return layout
    }
}

// MARK: - UICollectionViewDataSource
extension ProductsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.displayedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let product = viewModel.displayedProducts[indexPath.row]
        cell.configure(product: product, isGrid: viewModel.isGridLayout)
        return cell
    }
    /// add footer if loading
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            return UICollectionReusableView()
        }
        
        if viewModel.isLoading {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingFooterView.reuseIdentifier,
                for: indexPath
            ) as! LoadingFooterView
            return footer
        }
        
        return UICollectionReusableView()
    }
    
}

// MARK: - UICollectionViewDelegate
extension ProductsViewController: UICollectionViewDelegate {
    /// handle tapping to go to the details view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.displayedProducts[indexPath.row]
        viewModel.pushToDetailsView(product: product)
    }
    /// handle scrolling to fetch new products
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let height = scrollView.frame.size.height
//        
//        // Prevent triggering when content height is too small
//        guard contentHeight > height, !viewModel.isLoading else { return }
//        
//        if offsetY >= contentHeight - height {
//            guard !viewModel.allProductLoaded else { return }
//            viewModel.loadMore()
//        }
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Prevent triggering when content height is too small or loading is in progress
        guard contentHeight > height,
              !viewModel.isLoading,
              !viewModel.allProductLoaded else { return }

        // Trigger load more only once when near the bottom
        if offsetY > contentHeight - height - 100 {
            viewModel.isLoading = true
            viewModel.loadMore()
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductsViewController:  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return viewModel.isLoading ? CGSize(width: collectionView.frame.width, height: 50) : .zero
    }
}
