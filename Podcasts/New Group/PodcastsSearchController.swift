//
//  PodcastsViewController.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/16/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    var podcasts = [
        
         Podcast(trackName: "Lets Build That App", artistName: "Brian Voong"),
         Podcast(trackName: "Some Podcast", artistName: "Some Author")
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
        
//        let url = "https://itunes.apple.com/search?term=\(searchText)"
        
        let url = "https://itunes.apple.com/search"
        
        let parameters = ["term": searchText, "media": "podcasts"]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to contact server!", err)
                return
                
            }
            
            guard let data = dataResponse.data else { return }
            
            do {
                
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                self.podcasts = searchResult.results
                self.tableView.reloadData()
                
                
            } catch let decodeError {
                print("Failed to decode:", decodeError)
            }
        }
    }
        
        
        
        
        
        
        

    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
        
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
        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        cell.textLabel?.numberOfLines = -1
        return cell
    }
    
}
