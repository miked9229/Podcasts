//
//  RSSFeed.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/22/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import FeedKit

extension RSSFeed {
    
    func toEpisodes() -> [Episode] {
        
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        var episodes = [Episode]()
        
        items?.forEach({ (feedItem) in
            
            var episode = Episode(feedItem: feedItem)
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }
            
            
            episodes.append(episode)
            
        })
        
        return episodes
        
    }

}
