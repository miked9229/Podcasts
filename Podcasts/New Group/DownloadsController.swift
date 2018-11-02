//
//  DownloadsController.swift
//  Podcasts
//
//  Created by Michael Doroff on 10/27/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit

class DownloadsController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    
    var episodes = UserDefaults.standard.downloadedEpisodes()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupTableView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
        
    }
    
    //MARK:- Setup
    
    fileprivate func setupTableView() {
    
    let nib = UINib(nibName: "EpisodeCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: cellId)
        
        
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        
        let episode = self.episodes[indexPath.row]
        
        if episode.fileUrl != nil {
            
            UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode
                , playlistEpisodes: self.episodes)
            
        } else {
            
            let alertController = UIAlertController(title: "File URL not Found", message: "Cannot find local file, play using stream Url instead", preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode
                    , playlistEpisodes: self.episodes)
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alertController, animated: true)
            
        }
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    
}
