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
    
    override func viewDidLoad() {
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        
        collectionView?.backgroundColor = .blue
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellid)
        
        
    }
    
    //MARK:- UICollection View Delegate Methods / Spacing
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath)
        cell.backgroundColor = .black
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

