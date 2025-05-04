//
//  homepageViewModel.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 1.05.2025.
//

import Foundation
import RxSwift

class HomepageViewModel {
    
    let productRepo = ProductRepository.shared
    let productsList = BehaviorSubject<[Product]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() {
        productRepo.productsList
            .subscribe(onNext: { [weak self] newProductList in
                self?.productsList.onNext(newProductList)
            }, onError: { [weak self] error in
                self?.productsList.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func loadProducts() {
        productRepo.fetchProducts()
    }
    
    func search(query: String) {
        productRepo.searchProducts(query: query)
    }
    
    func filterByCategory(category: String?) {
        productRepo.filterProductsByCategory(category: category)
    }
}
