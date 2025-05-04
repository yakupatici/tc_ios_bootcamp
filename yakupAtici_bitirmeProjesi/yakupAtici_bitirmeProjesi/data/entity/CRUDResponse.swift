//
//  CRUDResponse.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 1.05.2025.
//

import Foundation

class CRUDResponse : Codable {
    var success:Int?
    var message:String?
    var sepet_urunler:[SepetUrun]?
}
