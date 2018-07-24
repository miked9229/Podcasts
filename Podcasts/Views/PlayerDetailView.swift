//
//  PlayersDetailView.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/23/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit

class PlayerDetailView: UIView {
    
    var episode: Episode! {
        didSet {
            titleLabel.text = episode.title
            authorLabel.text = episode.author

            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url)

        }
        
    }
    
    @IBAction func handleDismiss(_ sender: Any) {
    
        self.removeFromSuperview()
    
    }

    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var episodeImageView: UIImageView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    

}
