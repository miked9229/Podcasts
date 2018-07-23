//
//  EpisodeCell.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/22/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit
import SDWebImage

class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        didSet {

            textLabel?.numberOfLines = 0
            pubDateLabel.text = episode.pubDate?.description
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            pubDateLabel.text = dateFormatter.string(from: episode.pubDate!)
            
            
            guard let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "") else { return }
            episodeImageView.sd_setImage(with: url)
        
        
        }
    }
    
    @IBOutlet var episodeImageView: UIImageView!
    @IBOutlet var pubDateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 2
        }
    }
}
