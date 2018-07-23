//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/21/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    var podcast: Podcast? {
        didSet {
            
            navigationItem.title = podcast?.trackName ?? ""
            fetchEpisodes()
            
        }
    }
    
    public func fetchEpisodes() {
        
        guard let feedUrl = podcast?.feedUrl else { return }
        
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        
        guard let url = URL(string: secureFeedUrl) else { return }
        
        let parser = FeedParser(URL: url)
        parser?.parseAsync(result: { (result) in
            
            switch result {
            
            case let .rss(feed):
                
                self.episodes = feed.toEpisodes()
                DispatchQueue.main.async {
                   
                    self.tableView.reloadData()
                    
                }
                
                break

            case let .failure(error):
                
                print("Failed to parse feed:", error)
                break
                
            default:
                print("Found a feed....")
            }
        })
    }
    

    fileprivate let cellid = "cellid"
    
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    //MARK:- Setup Work
    
    fileprivate func setupTableView() {

        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
        tableView.tableFooterView = UIView()
        
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
}
