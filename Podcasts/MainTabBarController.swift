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
        setUpViewControllers()
        
        setupPlayerDetailsView()
                
    }
    
    @objc func minimizePlayerDetails() {
        
        maximizedTopLayoutConstraint.isActive = false
        bottomAnchorLayoutConstraint.constant = view.frame.height
        minimizedTopLayoutConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.miniPlayerView.alpha = 1
            
            
        })
    }
    
    func maximizePlayerDetails(episode: Episode?, playlistEpisodes: [Episode] = []) {
        minimizedTopLayoutConstraint.isActive = false
        maximizedTopLayoutConstraint.isActive = true
        maximizedTopLayoutConstraint.constant = 0
        bottomAnchorLayoutConstraint.constant = 0
        
        
        if episode != nil {
            
            playerDetailsView.episode = episode
            
        }
        
        playerDetailsView.playlistEpisodes = playlistEpisodes 
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.playerDetailsView.maximizedStackView.alpha = 1
            self.playerDetailsView.miniPlayerView.alpha = 0
            
        })
        
    }
    
    let playerDetailsView = PlayerDetailView.initFromNib()
    
    var maximizedTopLayoutConstraint: NSLayoutConstraint!
    var minimizedTopLayoutConstraint: NSLayoutConstraint!
    var bottomAnchorLayoutConstraint: NSLayoutConstraint!
    
    fileprivate func setupPlayerDetailsView() {
        
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        
        maximizedTopLayoutConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        
        maximizedTopLayoutConstraint.isActive = true
        
        
        bottomAnchorLayoutConstraint =  playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
       bottomAnchorLayoutConstraint.isActive = true
        
        

        minimizedTopLayoutConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
    
    func setUpViewControllers() {
        
        
        let layout = UICollectionViewFlowLayout()
        let favoritesController = FavoritesController(collectionViewLayout: layout)
        
        viewControllers = [
            
            generateNavigationController(with: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(with: favoritesController, title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
            
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
