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
        
        view.backgroundColor = .green
        
        let favoritesController = ViewController()
        
        favoritesController.tabBarItem.title =  "Favorites"
        
        
        viewControllers = [
            
            favoritesController
    
        ]
   
    
    }
    
    
    
    
}
