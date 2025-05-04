//
//  ProductRepository.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 1.05.2025.
//

import Foundation
import Alamofire
import RxSwift

struct SepetUrunlerResponse: Codable {
    var urunler_sepeti: [SepetUrun]?
    var success: Int?
}

class ProductRepository {
    
    static let shared = ProductRepository()
    
    private let disposeBag = DisposeBag()
    
    private let username = "yakup_atici"
    
    var productsList = BehaviorSubject<[Product]>(value: [])
    private var _originalProductsList = BehaviorSubject<[Product]>(value: [])
    var cartItemsSubject = BehaviorSubject<[SepetUrun]>(value: [])
    
    private var localCartBackup: [SepetUrun] = []
    
    private let baseURL = "http://kasimadalan.pe.hu/urunler/"
    
    init() {
        cartItemsSubject.onNext([])
    }
    
    func fetchProducts() {
        let url = "\(baseURL)tumUrunleriGetir.php"
        
        AF.request(url, method: .get).response { [weak self] response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(ProductResponse.self, from: data)
                    if let liste = cevap.urunler {
                        self?.productsList.onNext(liste)
                        self?._originalProductsList.onNext(liste)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchProductsWithCompletion(completion: @escaping ([Product]) -> Void) {
        let url = "\(baseURL)tumUrunleriGetir.php"
        
        AF.request(url, method: .get).responseDecodable(of: ProductResponse.self) { response in
            switch response.result {
            case .success(let productResponse):
                completion(productResponse.urunler ?? [])
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    func searchProducts(query: String) {
        do {
            let originalList: [Product] = try _originalProductsList.value()
            
            if query.isEmpty {
                productsList.onNext(originalList)
            } else {
                let filteredList = originalList.filter {
                    $0.ad?.starts(with: query) ?? false
                }
                productsList.onNext(filteredList)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func filterProductsByCategory(category: String?) {
        do {
            let originalList: [Product] = try _originalProductsList.value()
            
            if category == nil || category == "Hepsi" {
                productsList.onNext(originalList)
            } else {
                let filteredList = originalList.filter {
                    $0.kategori == category
                }
                productsList.onNext(filteredList)
            }
        } catch {
            print("Error : \(error.localizedDescription)")
        }
    }
    
    func fetchCartAPI() {
        let url = "\(baseURL)sepettekiUrunleriGetir.php"
        let params: [String: Any] = ["kullaniciAdi": username]
        
        print("[fetchCartAPI] Sepet çekiliyor (kullanıcı: \(username))")
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default)
            .responseDecodable(of: SepetUrunlerResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let sepetResponse):
                    if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                        print("[fetchCartAPI] Yanıt: \(responseStr)")
                    }

                    guard sepetResponse.success == 1, let hamSepetUrunleri = sepetResponse.urunler_sepeti else {
                        print("[fetchCartAPI] Başarısız yanıt (success != 1 veya urunler_sepeti yok/boş).")
                        self.cartItemsSubject.onNext([])
                        return
                    }
                    
                    print("[fetchCartAPI] Başarılı yanıt ve ürünler alındı: \(hamSepetUrunleri.count) adet.")
                    
                    let gruplanmisListe = self.groupCartItems(items: hamSepetUrunleri)
                    print("[fetchCartAPI] Gruplama tamamlandı. Sonuç: \(gruplanmisListe.count) benzersiz ürün.")
                    
                    self.cartItemsSubject.onNext(gruplanmisListe)
                    
                case .failure(let error):
                    print("[fetchCartAPI] İstek veya Decode hatası: \(error.localizedDescription)")
                    if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                        print("[fetchCartAPI] Hata anındaki yanıt verisi: \(responseStr)")
                    }
                    self.cartItemsSubject.onNext([])
                }
            }
    }
    
    private func groupCartItems(items: [SepetUrun]) -> [SepetUrun] {
        var gruplanmisSepet: [String: SepetUrun] = [:]
        for urun in items {
            if var mevcutUrun = gruplanmisSepet[urun.ad] {
                let yeniAdet = mevcutUrun.siparisAdeti + urun.siparisAdeti
                mevcutUrun = SepetUrun(sepetId: mevcutUrun.sepetId,
                                      ad: mevcutUrun.ad,
                                      resim: mevcutUrun.resim,
                                      kategori: mevcutUrun.kategori,
                                      fiyat: mevcutUrun.fiyat,
                                      marka: mevcutUrun.marka,
                                      siparisAdeti: yeniAdet,
                                      kullaniciAdi: mevcutUrun.kullaniciAdi)
                gruplanmisSepet[urun.ad] = mevcutUrun
            } else {
                gruplanmisSepet[urun.ad] = urun
            }
        }
        return Array(gruplanmisSepet.values)
    }
    
    func addToCartAPI(urun_id: Int, urun_adi: String, urun_resim: String, fiyat: Int, marka: String, kategori: String, adet: Int, completion: @escaping (Bool) -> Void) {
        let url = "\(baseURL)sepeteUrunEkle.php"
        let params: [String: Any] = [
            "ad": urun_adi,
            "resim": urun_resim,
            "fiyat": fiyat,
            "marka": marka,
            "kategori": kategori,
            "siparisAdeti": adet,
            "kullaniciAdi": username
        ]
        
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default)
            .responseData { [weak self] response in
                guard let self = self else { completion(false); return }
                
                switch response.result {
                case .success(let data):
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let success = json["success"] as? Int, success == 1 {
                        print("[addToCartAPI] Başarılı!")
                        completion(true)
                        self.fetchCartAPI()
                    } else {
                        print("[addToCartAPI] Başarısız veya yanıt anlaşılamadı.")
                        completion(false)
                    }
                case .failure(let error):
                    print("[addToCartAPI] Hata: \(error.localizedDescription)")
                    completion(false)
                }
            }
    }
    
    // Sepetten ürün silme fonksiyonu
    func removeFromCartAPI(sepet_urun_id: Int, completion: @escaping (Bool) -> Void) {
        let url = "\(baseURL)sepettenUrunSil.php"
        let params: [String: Any] = [
            "sepetId": sepet_urun_id,
            "kullaniciAdi": username
        ]
        
        print("\n[removeFromCartAPI] Sepetten ürün siliniyor (ID: \(sepet_urun_id))")
        print("[removeFromCartAPI] Parametreler: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default)
            .responseDecodable(of: CRUDResponse.self) { [weak self] response in
                guard let self = self else {
                    completion(false)
                    return
                }
                
                
                if let statusCode = response.response?.statusCode {
                    print("[removeFromCartAPI] HTTP Status: \(statusCode)")
                }
                
                 if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                     print("[removeFromCartAPI] Yanıt: \(responseStr)")
                 }
                
                switch response.result {
                case .success(let crudResponse):
              
                    if crudResponse.success == 1 {
                        print("[removeFromCartAPI] Başarılı! Ürün sepetten silindi.")
                        completion(true)
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            print("[removeFromCartAPI] API'den sepeti yeniliyorum")
                            self.fetchCartAPI()
                        }
                    } else {
                     
                        completion(false)
                    }
                    
                case .failure(let error):
                    completion(false)
                }
            }
    }
}
