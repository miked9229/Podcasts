//
//  PlayerDetailsView.swift
//  Podcasts
//
//  Created by Michael Doroff on 9/16/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit

extension PlayerDetailView {
    
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            
        } else if gesture.state == .changed {
            
            handlePanChanged(gesture: gesture)
            
        } else if gesture.state == .ended {
            
            handlePanEnded(gesture: gesture)
            
        }
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        self.maximizedStackView.alpha = -translation.y / 200
        self.miniPlayerView.alpha = 1 + translation.y / 200
        
        
    }
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.transform = .identity
            
            if translation.y < -200 || velocity.y < -500 {
                
                let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
                
                mainTabBarController?.maximizePlayerDetails(episode: nil)
                gesture.isEnabled = false
            } else {
                
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
                
            }
        })
    }
    
    @objc func handleTapMaximize() {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: nil)
        panGesture.isEnabled = false
    }
    
    
}
