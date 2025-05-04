//
//  ProfileViewController.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 30.04.2025.
//
import UIKit

let trendyolOrangeColor = UIColor.trendyolOrange
class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Yakup Atıcı"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "envelope.fill"))
        iv.tintColor = .systemGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "yakupatici@gmail.com "
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "phone.fill"))
        iv.tintColor = .systemGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "+90 (552) 312-2125"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
   
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.backgroundColor = .systemGroupedBackground
        return tableView
    }()
    
    
    private let profileMenuItems: [(icon: String, title: String)] = [
        ("mappin.and.ellipse", "Adreslerim"),
        ("heart.fill", "Favorilerim"),
        ("shippingbox.fill", "Siparişlerim"),
        ("gearshape.fill", "Hesap Ayarları"),
        ("rectangle.portrait.and.arrow.right", "Çıkış Yap")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        configureNavigationBar()
        setupUI()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData() 
    }

    func configureNavigationBar() {
      
        self.navigationItem.title = "Profilim"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.trendyolOrange
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Pacifico-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupUI() {
      
        view.addSubview(nameLabel)
        view.addSubview(emailIcon)
        view.addSubview(emailLabel)
        view.addSubview(phoneIcon)
        view.addSubview(phoneLabel)
        view.addSubview(separatorView)
        
       
        view.addSubview(tableView)
        
        let padding: CGFloat = 16
        let smallPadding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            
            emailIcon.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding * 1.5),
            emailIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailIcon.widthAnchor.constraint(equalToConstant: 20),
            emailIcon.heightAnchor.constraint(equalToConstant: 20),

            emailLabel.centerYAnchor.constraint(equalTo: emailIcon.centerYAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: emailIcon.trailingAnchor, constant: smallPadding),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
        
            phoneIcon.topAnchor.constraint(equalTo: emailIcon.bottomAnchor, constant: padding),
            phoneIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            phoneIcon.widthAnchor.constraint(equalToConstant: 20),
            phoneIcon.heightAnchor.constraint(equalToConstant: 20),
            
            phoneLabel.centerYAnchor.constraint(equalTo: phoneIcon.centerYAnchor),
            phoneLabel.leadingAnchor.constraint(equalTo: phoneIcon.trailingAnchor, constant: smallPadding),
            phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
        
            separatorView.topAnchor.constraint(equalTo: phoneIcon.bottomAnchor, constant: padding),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
          
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        let item = profileMenuItems[indexPath.row]
        
        
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.image = UIImage(systemName: item.icon)
        content.imageProperties.tintColor = trendyolOrangeColor
        cell.contentConfiguration = content
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = profileMenuItems[indexPath.row]
        print("Selected: \(selectedItem.title)")
       
    }
    
   
    
}
