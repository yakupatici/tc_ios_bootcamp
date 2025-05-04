
//
//  Product.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 1.05.2025.
//
import Foundation

class Product : Codable {
    var id: Int?
    var ad: String?
    var resim: String?
    var kategori: String?
    var fiyat: Int?
    var marka: String?
    
    init(id: Int? = nil, ad: String? = nil, resim: String? = nil, kategori: String? = nil, fiyat: Int? = nil, marka: String? = nil) {
        self.id = id
        self.ad = ad
        self.resim = resim
        self.kategori = kategori
        self.fiyat = fiyat
        self.marka = marka
    }
}
