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

extension Notification.Name {
    
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
    
}


class APIService {
    
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search"
    
    //singelton
    
    static let shared = APIService()
    
    
    public func downloadEpisode(episode: Episode) {

        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(episode.streamUrl ?? "" , to: downloadRequest).downloadProgress { (progress) in
            
            // I want to notify DownloadsController about my download progress somehow
         
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title ?? "", "progress":progress.fractionCompleted])
            
            
            }.response { (resp) in
                
                
                let episodeDownloadCompleteTuple = EpisodeDownloadCompleteTuple(fileUrl: resp.destinationURL?.absoluteString ?? "", episode.title ?? "")
                
                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadCompleteTuple, userInfo: nil)
                
                
                // We want to update UserDefaults download episode with this temp file somehow
                
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                guard let index = downloadedEpisodes.index(where: {$0.title == episode.title && $0.author == episode.author}) else { return }
                
                
                downloadedEpisodes[index].fileUrl = resp.destinationURL?.absoluteString  ?? ""
                
                do {
                    
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
                
                } catch let err {
                    print("Failed to encode downloaded episodes with file url update:", err)
                    
                }
                
        }
    
    }
    
    public func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        
        guard let url = URL(string: secureFeedUrl) else { return }
        
        
        DispatchQueue.global(qos: .background).async {
            
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
        
            
    }
       
    public func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
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
