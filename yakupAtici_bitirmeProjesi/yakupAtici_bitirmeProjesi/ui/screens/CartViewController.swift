//
//  CartViewController.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 30.04.2025.
//

import UIKit
import Kingfisher
import RxSwift


class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let productRepo = ProductRepository.shared
    
    private let disposeBag = DisposeBag()
    
    private var currentCartItems: [SepetUrun] = []
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.identifier)
        return tv
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .right
        label.text = "Toplam: 0 ₺"
        return label
    }()
    
    private let freeShippingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.text = "✅🛒 Ücretsiz Kargo"
        return label
    }()
    
  
    private let placeOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sepeti Onayla ve Sipariş Ver", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor.trendyolOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private let emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "Sepetiniz boş."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        setupUI()
        setupBindings()
        print("CartViewController: viewDidLoad completed")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CartViewController: viewWillAppear")
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "Sepetim"
        
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
        view.addSubview(totalLabel)
        view.addSubview(freeShippingLabel)
        view.addSubview(placeOrderButton)
        view.addSubview(emptyCartLabel)
        
        let padding: CGFloat = 16
        let smallPadding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            placeOrderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            placeOrderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            placeOrderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            placeOrderButton.heightAnchor.constraint(equalToConstant: 50),

            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            totalLabel.bottomAnchor.constraint(equalTo: placeOrderButton.topAnchor, constant: -smallPadding),
            totalLabel.heightAnchor.constraint(equalToConstant: 30),
            
            freeShippingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            freeShippingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            freeShippingLabel.bottomAnchor.constraint(equalTo: totalLabel.topAnchor, constant: -smallPadding),
            freeShippingLabel.heightAnchor.constraint(equalToConstant: 20),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: freeShippingLabel.topAnchor, constant: -smallPadding),
            
            emptyCartLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyCartLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: padding),
            emptyCartLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -padding)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        
        placeOrderButton.addTarget(self, action: #selector(placeOrderTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        productRepo.cartItemsSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (cartItems: [SepetUrun]) in
                guard let self = self else { return }
                print("CartViewController: Sepet Subject güncellendi, \(cartItems.count) ürün alındı.")
                
                for (index, item) in cartItems.enumerated() {
                    print("  >> Alınan Ürün \(index): id=\(item.sepetId), name=\(item.ad)")
                }
                
                self.currentCartItems = cartItems
                
                print("CartViewController: currentCartItems güncellendi. Yeni ürün sayısı: \(self.currentCartItems.count)")
                for item in self.currentCartItems {
                     print("  -- Lokal Ürün: \(item.ad)")
                }
                
                self.updateUIElements()
            }, onError: { error in
                
                print("CartViewController: Sepet Subject hatası - \(error.localizedDescription)")
                self.currentCartItems = []
                self.updateUIElements()
            })
            .disposed(by: disposeBag)
    }

    private func updateUIElements() {
        var total: Int = 0
        for item in currentCartItems {
            total += item.toplamFiyatInt
        }

       
        let isFreeShipping = total >= 5000
        let shippingFee = isFreeShipping ? 0 : 150
        let finalTotal = total + shippingFee

        totalLabel.text = "Toplam: \(finalTotal) ₺"

        if isFreeShipping {
            freeShippingLabel.text = "✅🛒 Ücretsiz Kargo"
            freeShippingLabel.textColor = .systemGreen
        } else {
            freeShippingLabel.text = "📦 Kargo Ücreti: 150 ₺"
            freeShippingLabel.textColor = .systemRed
        }

        let isEmpty = currentCartItems.isEmpty
        emptyCartLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        totalLabel.isHidden = isEmpty
        freeShippingLabel.isHidden = isEmpty
        placeOrderButton.isHidden = isEmpty

        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.identifier, for: indexPath) as! CartItemCell
        let item = currentCartItems[indexPath.row]
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = currentCartItems[indexPath.row]
            
            let cartItemIdInt = itemToDelete.sepetId
            
            
            productRepo.removeFromCartAPI(sepet_urun_id: cartItemIdInt) { success in
                if !success {
                    DispatchQueue.main.async {
                        print("API: Ürün sepetten silinemedi (completion).")
                        let alert = UIAlertController(title: "Hata", message: "Ürün sepetten silinirken bir sorun oluştu.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
 
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Sil"
    }

    
    @objc private func placeOrderTapped() {
        print("Sipariş Ver butonuna tıklandı!")
        
        
        let alert = UIAlertController(title: "Siparişiniz Alındı", message: "Siparişiniz başarıyla oluşturuldu.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
