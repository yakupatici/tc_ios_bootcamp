//
//  ViewController.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 30.04.2025.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
  
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewModel = HomepageViewModel()
    private let disposeBag = DisposeBag()
    
    private var products: [Product] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 48) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
   
    private var categoryStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureNavigationBar()
        setupUI()
        setupBindings()
        
        viewModel.loadProducts()
        
        searchBar.delegate = self
    }
    
    private func setupUI() {
        categoryStackView = UIStackView()
        categoryStackView.axis = .horizontal
        categoryStackView.distribution = .fillEqually
        categoryStackView.spacing = 8
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let categories = ["Hepsi", "Teknoloji", "Aksesuar", "Kozmetik"]
        for category in categories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.backgroundColor = UIColor(named: "trendyolOrange")?.withAlphaComponent(0.1)
            button.setTitleColor(UIColor(named: "trendyolOrange"), for: .normal)
            button.layer.cornerRadius = 8
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            categoryStackView.addArrangedSubview(button)
        }
        
        view.addSubview(collectionView)
        view.addSubview(categoryStackView)
        
        NSLayoutConstraint.activate([
            categoryStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            categoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryStackView.heightAnchor.constraint(equalToConstant: 40),

            collectionView.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
   
    private func setupBindings() {
        viewModel.productsList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] products in
                guard let self = self else { return }
                self.products = products
                self.collectionView.reloadData()
            }, onError: { error in
                print("Error observing products: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "iShop"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.trendyolOrange
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Pacifico-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        guard let categoryTitle = sender.title(for: .normal) else { return }
        
        viewModel.filterByCategory(category: categoryTitle == "Hepsi" ? nil : categoryTitle)
        
        updateCategoryButtonSelection(selectedButton: sender)
    }
    
    private func updateCategoryButtonSelection(selectedButton: UIButton) {
        for case let button as UIButton in categoryStackView.arrangedSubviews {
            if button == selectedButton {
                button.backgroundColor = UIColor(named: "trendyolOrange")?.withAlphaComponent(0.3)
                button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            } else {
                button.backgroundColor = UIColor(named: "trendyolOrange")?.withAlphaComponent(0.1)
                button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            }
        }
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            fatalError("Unable to dequeue ProductCollectionViewCell")
        }
        
        let product = products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.item]
        print("Selected product: \(selectedProduct.ad ?? "Unknown")")
        
        let detailVC = DetailPageViewController()
        detailVC.product = selectedProduct
        
        let navigationController = UINavigationController(rootViewController: detailVC)
        present(navigationController, animated: true, completion: nil)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        viewModel.search(query: "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
