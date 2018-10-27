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
        setupNavigationBarButtons()
        
    }
    
    //MARK:- Setup Work
    
    fileprivate func setupNavigationBarButtons() {
        
        //Let's check if we have already saved the podcast as favorite
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        let hasFavorited = savedPodcasts.index(where: {$0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName}) != nil
        
        if hasFavorited {
            
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)

        } else {
            
            navigationItem.rightBarButtonItems = [
                
                UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(handleSaveFavorite)),
                
            ]
        }
        
    }
    
    @objc fileprivate func handleFetchSavedFavorite() {
        
        // how to retrieve our Podcast from UserDefaults
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return }
//        let podcast = NSKeyedUnarchiver.unarchiveObject(with: data) as? Podcast
        
       let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast]
        
        savedPodcasts?.forEach({ (p) in
            print(p.trackName ?? "")
        })
        
    }
        @objc fileprivate func handleSaveFavorite() {
        
        guard let podcast = self.podcast else { return }
        // 1. Transform Podcast into some kind of data
        
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast)
        let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    
    
        showBadgeHighlight()
    
    
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
            
            
            
    }
    
    fileprivate func showBadgeHighlight() {
        
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
        
    }
    
    fileprivate func setupTableView() {

        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
        tableView.tableFooterView = UIView()
        
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let downloadAction = UITableViewRowAction(style: .default, title: "Download") { (_, _) in
            print("Downloading episode into User Defaults")
            
        let episode = self.episodes[indexPath.row]
        UserDefaults.standard.downloadEpisode(episode: episode)
        
        }
        
        return [downloadAction]
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = .darkGray
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
         let episode = self.episodes[indexPath.row]
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        
        mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
    
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
