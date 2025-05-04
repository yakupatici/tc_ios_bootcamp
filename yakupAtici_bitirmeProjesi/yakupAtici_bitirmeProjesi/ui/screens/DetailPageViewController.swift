import UIKit
import Kingfisher 

class DetailPageViewController: UIViewController {
    
    var product: Product?

    private var currentQuantity: Int = 1
    
    // MARK: - UI Elements
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Miktar:"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.value = 1
        stepper.stepValue = 1
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
       
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .right // Sağa yaslayalım
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sepete Ekle", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .trendyolOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
        configureViewDirectly()
        setupInteractions()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kapat", style: .done, target: self, action: #selector(closeButtonTapped))
        
        // Add heart button to right side of navigation bar
        let heartButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = heartButton
        
        // Update heart button based on UserDefaults-stored favorites
        if let productId = product?.id {
            let savedIds = UserDefaults.standard.array(forKey: "favoriteIds") as? [Int] ?? []
            let isFavorite = savedIds.contains(productId)
            updateHeartButton(isFavorite: isFavorite)
        }
        
        title = "Ürün Detayı"
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let productId = product?.id else { return }
        // Toggle favorite in UserDefaults
        var ids = UserDefaults.standard.array(forKey: "favoriteIds") as? [Int] ?? []
        let isFavorite: Bool
        if let idx = ids.firstIndex(of: productId) {
            ids.remove(at: idx)
            isFavorite = false
        } else {
            ids.append(productId)
            isFavorite = true
        }
        UserDefaults.standard.set(ids, forKey: "favoriteIds")
        updateHeartButton(isFavorite: isFavorite)
    }
    
    private func updateHeartButton(isFavorite: Bool) {
        if let heartButton = navigationItem.rightBarButtonItem {
            heartButton.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
            heartButton.tintColor = isFavorite ? UIColor(named: "trendyolOrange") ?? .orange : .systemRed
        }
    }
    
    private func setupUI() {
        
        view.addSubview(productImageView)
        view.addSubview(nameLabel)
        view.addSubview(brandLabel)
        view.addSubview(priceLabel)
        view.addSubview(quantityTitleLabel)
        view.addSubview(quantityStepper)
        view.addSubview(quantityLabel)
        view.addSubview(totalPriceLabel)
        view.addSubview(addToCartButton)
        
        let padding: CGFloat = 16
        let smallPadding: CGFloat = 8
        
        NSLayoutConstraint.activate([
           
            productImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            productImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: padding * 2),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            brandLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding / 2),
            brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            brandLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            priceLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: padding),
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Ortala
            
            quantityTitleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: padding * 2),
            quantityTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            quantityStepper.centerYAnchor.constraint(equalTo: quantityTitleLabel.centerYAnchor),
            quantityStepper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            quantityLabel.centerYAnchor.constraint(equalTo: quantityTitleLabel.centerYAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: quantityStepper.leadingAnchor, constant: -smallPadding),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),
            
            totalPriceLabel.topAnchor.constraint(equalTo: quantityTitleLabel.bottomAnchor, constant: padding), // Quantity Title altına aldık
            totalPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: padding),
            totalPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),

            addToCartButton.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: padding * 2),
            addToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            addToCartButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
    
    private func configureViewDirectly() {
        guard let product = product else { return }
        
        nameLabel.text = product.ad
        brandLabel.text = product.marka
        priceLabel.text = "\(product.fiyat ?? 0) ₺"
        quantityLabel.text = "\(currentQuantity)"
        updateTotalPriceLabel()
        
        if let imageName = product.resim,
           let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)") {
            productImageView.kf.indicatorType = .activity
            productImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo.fill"))
        } else {
            productImageView.image = UIImage(systemName: "photo.fill")
        }
        
        quantityStepper.value = Double(currentQuantity)
    }
    
   
    private func updateTotalPriceLabel() {
        let total = (product?.fiyat ?? 0) * currentQuantity
        totalPriceLabel.text = "Toplam: \(total) ₺"
    }
    

    private func setupInteractions() {
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        currentQuantity = Int(sender.value)
        quantityLabel.text = "\(currentQuantity)"
        updateTotalPriceLabel()
    }
    
   
    @objc private func addToCartButtonTapped() {
        guard let product = product else {
            print("addToCartButtonTapped: Ürün bilgisi yok.")
            showSimpleAlert(title: "Hata", message: "Ürün bilgisi bulunamadı.")
            return
        }
        
        let productId = product.id ?? 0
        print("Sepete ekleniyor: \(currentQuantity) x \(product.ad ?? "Bilinmeyen ürün") (ID: \(productId))")
        
       
        
        let productRepo = ProductRepository.shared
        productRepo.addToCartAPI(
            urun_id: productId,
            urun_adi: product.ad ?? "İsimsiz Ürün",
            urun_resim: product.resim ?? "",
            fiyat: product.fiyat ?? 0,
            marka: product.marka ?? "",
            kategori: product.kategori ?? "",
            adet: currentQuantity
        ) { [weak self] success in
            print("addToCartAPI completion: success=\(success)")
            
     
            DispatchQueue.main.async {
                guard let self = self else { 
                    print("addToCartAPI completion: nil oldu.")
                    return 
                }
                
                if success {
                    print("Ürün sepete eklendi! ")
                    self.showSimpleAlert(title: "Başarılı", message: "Ürün sepete eklendi.")
                } else {
                    print("Hata: Ürün sepete eklenemedi. Alert gösteriliyor...")
                    self.showSimpleAlert(title: "Hata", message: "Ürün sepete eklenirken bir sorun oluştu. Lütfen tekrar deneyin.")
                }
            }
        }
        print("addToCartAPI isteği gönderildi.")
    }
    
   
    private func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        
 
        present(alert, animated: true) {
             print("Alert başarıyla sunuldu.")
        }
    }
} 
