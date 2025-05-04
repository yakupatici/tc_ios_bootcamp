//
//  DetailPageViewModel.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 1.05.2025.
//

import Foundation
import UIKit 

class DetailPageViewModel {
    
    private var product: Product?
    

    var currentQuantity: Int = 1
    
    
    var productName: String? { product?.ad }
    var productBrand: String? { product?.marka }
    var productPriceString: String {
        guard let price = product?.fiyat else { return "Fiyat Bilgisi Yok" }
        return "\(price) ₺"
    }
    var productImageURL: URL? {
        guard let imageName = product?.resim else { return nil }
        return URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)")
    }
    var quantityString: String { "\(currentQuantity)" }
    var totalPriceString: String {
        guard let price = product?.fiyat else { return "Toplam: -" }
        let total = price * currentQuantity
        return "Toplam: \(total) ₺"
    }
   
    init(product: Product?) {
        self.product = product
        
    }
    
 
    
    func quantityChanged(to quantity: Int) {
        guard quantity >= 1 else { return }
        currentQuantity = quantity
        print("Selected quantity (ViewModel): \(currentQuantity)")
    }
    
   
}

