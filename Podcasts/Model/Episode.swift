//
//  Episode.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/21/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit
import FeedKit

struct Episode {
    let title: String?
    let pubDate: Date?
    let description: String?
    
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
    }
}

