//
//  LaunchScreenViewController.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 2.05.2025.
//

import UIKit
import Lottie

class LaunchScreenViewController: UIViewController {

    private var animationView: LottieAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange

    
        let titleLabel = UILabel()
        titleLabel.text = "iShop"
        titleLabel.font = UIFont(name: "Pacifico-Regular", size: 32) ?? UIFont.systemFont(ofSize: 32)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        
        animationView = LottieAnimationView(name: "Animation - 1746218511661")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.addSubview(animationView)

       
        let sloganLabel = UILabel()
        sloganLabel.text = "Aradığınız Her Şey Burada"
        sloganLabel.font = UIFont(name: "Pacifico-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20)
        sloganLabel.textColor = .black
        sloganLabel.textAlignment = .center
        sloganLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sloganLabel)

        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            animationView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            animationView.heightAnchor.constraint(equalToConstant: 300),

            sloganLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 32),
            sloganLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])


        animationView.play { _ in
            let tabBarVC = TabBarVC()
            UIApplication.shared.windows.first?.rootViewController = tabBarVC
        }
    }

    private func groupCartItems(items: [SepetUrun]) -> [SepetUrun] {
        var gruplanmisSepet: [String: SepetUrun] = [:]
        for urun in items {
            if var mevcutUrun = gruplanmisSepet[urun.ad] {
                // Ürün zaten varsa, adedini artır ve struct'ı güncelle
                let yeniAdet = mevcutUrun.siparisAdeti + urun.siparisAdeti
                mevcutUrun = SepetUrun(sepetId: mevcutUrun.sepetId, // İlk ID'yi koru
                                      ad: mevcutUrun.ad,
                                      resim: mevcutUrun.resim,
                                      kategori: mevcutUrun.kategori,
                                      fiyat: mevcutUrun.fiyat,
                                      marka: mevcutUrun.marka,
                                      siparisAdeti: yeniAdet, // Yeni toplam adet
                                      kullaniciAdi: mevcutUrun.kullaniciAdi)
                gruplanmisSepet[urun.ad] = mevcutUrun // Güncellenmiş struct'ı dictionary'e geri koy
            } else {
                // Ürün ilk kez ekleniyorsa
                gruplanmisSepet[urun.ad] = urun
            }
        }
        // Dictionary'deki gruplanmış ürünleri dizi olarak döndür
        return Array(gruplanmisSepet.values)
    }
}
