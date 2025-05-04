//
//  ProductResponse.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 1.05.2025.
//
import Foundation

class ProductResponse: Codable {
    var success: Int?
    var urunler: [Product]?
    
    init(success: Int? = nil, urunler: [Product]? = nil) {
        self.success = success
        self.urunler = urunler
    }
} 
