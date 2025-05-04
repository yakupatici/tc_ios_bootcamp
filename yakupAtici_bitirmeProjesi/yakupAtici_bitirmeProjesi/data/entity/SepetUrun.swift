//
//  SepetUrun.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 1.05.2025.
//

import Foundation

struct SepetUrun: Codable {
    let sepetId: Int
    let ad: String
    let resim: String
    let kategori: String
    let fiyat: Int
    let marka: String
    let siparisAdeti: Int
    let kullaniciAdi: String
    
    enum CodingKeys: String, CodingKey {
        case sepetId
        case ad
        case resim
        case kategori
        case fiyat
        case marka
        case siparisAdeti
        case kullaniciAdi
    }
    
    var sepetUrunIdString: String {
        return "\(sepetId)"
    }
    
    var adetInt: Int { siparisAdeti }
    
    var toplamFiyatInt: Int {
        return fiyat * siparisAdeti
    }
    
    func toProduct() -> Product {
        let product = Product()
        product.ad = ad
        product.resim = resim
        product.fiyat = fiyat
        product.marka = marka
        product.kategori = kategori
        return product
    }
}
