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
        
        
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        
        }
        
        
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
    
        let window = UIApplication.shared.keyWindow
        
        let playerDetailView = Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)?.first as! PlayerDetailView
        
        playerDetailView.episode = episode

        
        playerDetailView.frame = self.view.frame
        window?.addSubview(playerDetailView)
    
    
    }
    
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
