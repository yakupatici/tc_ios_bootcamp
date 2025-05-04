
//
//  CartItem.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 1.05.2025.
//
import Foundation

struct CartItem: Codable {
    let product: Product
    var quantity: Int
    
    var totalPrice: Int {
        return (product.fiyat ?? 0) * quantity
    }
} 
