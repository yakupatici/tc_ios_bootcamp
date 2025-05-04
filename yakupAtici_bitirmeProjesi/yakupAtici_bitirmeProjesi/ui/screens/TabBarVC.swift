//
//  TabBarVC.swift
//  yakupAtici_bitirmeProjesi
//
//  Created by Yakup Atici on 30.04.2025.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        
    }
 
    
    let trendyolOrange = UIColor(named: "trendyolOrange")

  func setupTabBar(){
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
      let favoritesVC = FavoritesViewController()
      let cartVC = CartViewController()
      let profileVC = ProfileViewController()
      
      
      let homeNav = UINavigationController(rootViewController: homeVC)
      let favoritesNav = UINavigationController(rootViewController: favoritesVC)
      let cartNav = UINavigationController(rootViewController: cartVC)
      let profileNav = UINavigationController(rootViewController: profileVC)
      
      homeNav.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(systemName: "house.fill"), tag: 0)
      favoritesNav.tabBarItem = UITabBarItem(title: "Favoriler", image: UIImage(systemName: "heart.fill"), tag: 1)
      cartNav.tabBarItem = UITabBarItem(title: "Sepet", image: UIImage(systemName: "cart.fill"), tag: 2)
      profileNav.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.crop.circle.fill"), tag: 3)
      
      viewControllers = [homeNav, favoritesNav, cartNav, profileNav]
      
      selectedIndex = 0
      

      self.tabBar.tintColor = trendyolOrange
      
      self.tabBar.unselectedItemTintColor = .systemGray
    }
    
}
