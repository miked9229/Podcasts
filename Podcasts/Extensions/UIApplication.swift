//
//  UIApplication.swift
//  Podcasts
//
//  Created by Michael Doroff on 9/19/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    static func mainTabBarController() -> MainTabBarController? {
    
        return shared.keyWindow?.rootViewController as? MainTabBarController
    
    
    }
    
}
