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
    static let downloadedEpisodeKey = "downloadedEpisodeKey"
    
    func downloadEpisode(episode: Episode) {
        
        do {
            
            var episodes = downloadedEpisodes()
            episodes.append(episode)
            let data = try JSONEncoder().encode(episodes)
            
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
            
        } catch let encodeErr {
            
            print("Failed to encode episode:", encodeErr)
            
        }
        
    }
    
    func downloadedEpisodes() -> [Episode] {
        
        guard let episodesData = UserDefaults.standard.data(forKey: UserDefaults.downloadedEpisodeKey) else { return [] }
        
        
        do {
            let episodesArray = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodesArray
            
        } catch let decodeErr {
            print("Failed to decode:", decodeErr)
            
            
        }
        
        return []
    }
    
    
    func savedPodcasts() -> [Podcast] {
        
        guard let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
        
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastData) as? [Podcast] else { return [] }
        
        return savedPodcasts
        
    }
    
    
    
}
