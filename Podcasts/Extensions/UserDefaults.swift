//
//  UserDefaults.swift
//  Podcasts
//
//  Created by Michael Doroff on 10/20/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import Foundation



extension UserDefaults {
    

    static let favoritedPodcastKey = "favoritedPodcastKey"
    
    func savedPodcasts() -> [Podcast] {
        
        
        guard let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
        
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastData) as? [Podcast] else { return [] }
        
        return savedPodcasts
        
    }
    
    
    
}
