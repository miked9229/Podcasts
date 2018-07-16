//
//  MainTabBarController.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/14/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        
        tabBar.tintColor = .purple
     
    
    }
    
    //MARK:- Setup Functions 
    
    func setUpViewControllers() {
        
        
        viewControllers = [
            
            generateNavigationController(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads")),
            generateNavigationController(with: ViewController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(with: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites"))
            
        ]
        
    }
    
    
    //MARK:- Helper Functions
    
    fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    
    }
    
}
