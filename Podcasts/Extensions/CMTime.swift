//
//  CMTime.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/28/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: " %02d:%02d", minutes, seconds)
        
        return timeFormatString
    
    }
    
    
    
    
}
