//
//  FavoritePodcastCell.swift
//  Podcasts
//
//  Created by Michael Doroff on 10/11/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit


class FavoritePodcastCell: UICollectionViewCell {
    
    var podcast: Podcast! {
        
        didSet {
            
            nameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            let url = URL(string: podcast.artworkUrl600 ?? "")
            imageView.sd_setImage(with: url)
        }
        
    }
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "heart"))
    let nameLabel = UILabel()
    let artistNameLabel = UILabel()
    
    fileprivate func stylizeUI() {
        nameLabel.text = "Podcast Name"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        artistNameLabel.text = "Artist Name"
        artistNameLabel.font = UIFont.systemFont(ofSize: 14)
        artistNameLabel.textColor = .lightGray
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    }
    
    fileprivate func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [imageView,nameLabel,artistNameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stylizeUI()
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
