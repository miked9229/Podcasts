//
//  APIService.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/19/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search"
    
    //singelton
    
    static let shared = APIService()
    
    public func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        
        
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        
        guard let url = URL(string: secureFeedUrl) else { return }
        
        let parser = FeedParser(URL: url)
        parser?.parseAsync(result: { (result) in
            
            
            if let err = result.error {
                print("Failed to parse XML feed", err)
                return
            }
            
            guard let feed = result.rssFeed else { return }
            
            
            let episodes = feed.toEpisodes()
            completionHandler(episodes)
        })
    }
    
    
    
    public func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
        print("Searching for podcasts...")
        
        let parameters = ["term": searchText, "media": "podcast"]
        
        Alamofire.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            
            if let err = dataResponse.error {
                print("Failed to contact yahoo", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                print(searchResult.resultCount)
                
                completionHandler(searchResult.results)
                
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
    }
    
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
        
    }    
}
