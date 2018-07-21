//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/21/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit

class EpisodesController: UITableViewController {
    
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName ?? ""
            
        }
    }
    
    struct Epsidode {
        let title: String?
    }
    
    fileprivate let cellid = "cellid"
    
    var episodes = [
        
        Epsidode(title: "First Episode"),
        Epsidode(title: "Second Episode"),
        Epsidode(title: "Third Episode"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    //MARK:- Setup Work
    
    fileprivate func setupTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
        tableView.tableFooterView = UIView()
        
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = "\(episode.title ?? "")"
        return cell
    }
    
}
