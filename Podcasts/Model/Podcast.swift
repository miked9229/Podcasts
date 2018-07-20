//
//  Podcast.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/16/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import Foundation



struct Podcast: Decodable {
    
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
}


