//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/20/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit
import SDWebImage


class PodcastCell: UITableViewCell {
    
    
    @IBOutlet var podcastImageView: UIImageView!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var episodeCountLabel: UILabel!
    
    var podcast: Podcast! {
        didSet {
            artistNameLabel.text = podcast.artistName
            trackNameLabel.text = podcast.trackName
            
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
            
            guard let url = URL(string:  podcast.artworkUrl600 ?? "") else { return }
        
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }

}

