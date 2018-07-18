//
//  PodcastsViewController.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/16/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let podcasts = [
        
         Podcast(name: "Lets Build That App", artistName: "Brian Voong"),
         Podcast(name: "Some Podcast", artistName: "Some Author")
    ]
    
    let cellid = "cellid"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
    }

    //MARK:- Setup Work
    
    fileprivate func setupSearchBar() {
    
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        //later implement Alamao Fire to search iTunes API
    }
    
    
    //MARK:- UITableView
    
    fileprivate func setupTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return podcasts.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        
        let podcast = self.podcasts[indexPath.row]
        cell.textLabel?.text = "\(podcast.name)\n\(podcast.artistName)"
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        cell.textLabel?.numberOfLines = -1
        return cell
    }
    
}
