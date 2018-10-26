//
//  FavoritesController.swift
//  Podcasts
//
//  Created by Michael Doroff on 10/9/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit

class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellid = "cellId"
    
    var podcasts = UserDefaults.standard.savedPodcasts()
    
    
    override func viewDidLoad() {
        
        setupCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        podcasts = UserDefaults.standard.savedPodcasts()
        collectionView?.reloadData()
        
        
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
    
    }
    
    fileprivate func setupCollectionView() {
        
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        
        collectionView?.backgroundColor = .white
        collectionView?.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellid)
        
        collectionView?.addGestureRecognizer(gesture)
        
        
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        let location = gesture.location(in: collectionView)
        
        guard let selectedIndexPath = collectionView?.indexPathForItem(at: location) else { return }
        
        let alertController = UIAlertController(title: "Remove Podcast", message: nil, preferredStyle: .actionSheet)
        
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            // Where we remove the podcast object from the collection view
            self.podcasts.remove(at: selectedIndexPath.item)
            
            self.collectionView?.deleteItems(at:[selectedIndexPath])
            
            // also remove item from UserDefaults

            let data = NSKeyedArchiver.archivedData(withRootObject: self.podcasts)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)

        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
        
    }
    
    //MARK:- UICollection View Delegate Methods / Spacing
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let episodeController = EpisodesController()
        episodeController.podcast = self.podcasts[indexPath.item]
        navigationController?.pushViewController(episodeController, animated: true)
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! FavoritePodcastCell
        
        
        cell.podcast = podcasts[indexPath.item]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        
        return CGSize(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

