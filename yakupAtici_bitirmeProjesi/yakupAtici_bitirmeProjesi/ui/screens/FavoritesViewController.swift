//
//  FavoritesViewController.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 30.04.2025.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private var favoritedProducts: [Product] = []
    private let productRepository = ProductRepository.shared
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    private let emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Favori ürün bulunmamaktadır."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = false 
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteProducts()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "Favoriler" 
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
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyMessageLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyMessageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            emptyMessageLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadFavoriteProducts() {
       
        let favoriteIds = UserDefaults.standard.array(forKey: "favoriteIds") as? [Int] ?? []
        
        productRepository.fetchProductsWithCompletion { [weak self] products in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.favoritedProducts = products.filter { product in
                    guard let id = product.id else { return false }
                    return favoriteIds.contains(id)
                }
                
                self.tableView.reloadData()
                self.updateEmptyState()
            }
        }
    }
    
    private func updateEmptyState() {
        emptyMessageLabel.isHidden = !favoritedProducts.isEmpty
        tableView.isHidden = favoritedProducts.isEmpty
    }
}


extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        
        let product = favoritedProducts[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = product.ad
        content.secondaryText = "\(product.fiyat ?? 0) ₺"
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product = favoritedProducts[indexPath.row]
        let detailVC = DetailPageViewController()
        detailVC.product = product
        
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
     
            let product = favoritedProducts[indexPath.row]
            guard let productId = product.id else { return }
            
          
            var ids = UserDefaults.standard.array(forKey: "favoriteIds") as? [Int] ?? []
            if let idx = ids.firstIndex(of: productId) {
                ids.remove(at: idx)
                UserDefaults.standard.set(ids, forKey: "favoriteIds")
            }
            
       
            favoritedProducts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateEmptyState()
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Sil"
    }

}
