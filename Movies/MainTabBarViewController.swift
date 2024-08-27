//
//  ViewController.swift
//  Movies
//
//  Created by Arabi's Mac on 26/8/2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow

        let vc1 = UINavigationController(rootViewController: HomeViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.title = "Home"
        
        tabBar.tintColor = .label

        setViewControllers([vc1], animated: true)
    }
}
