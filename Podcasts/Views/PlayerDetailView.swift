//
//  PlayersDetailView.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/23/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit
import AVKit

class PlayerDetailView: UIView {
    
    var episode: Episode! {
        didSet {
            miniEpisodeLabel.text = episode.title
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            
            PlayEpisode()

            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url)
            miniEpisodeImageView.sd_setImage(with: url)

        }
        
    }
    
    public func PlayEpisode() {
        
        guard let url = URL(string: episode.streamUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(1,2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            let duration = self?.player.currentItem?.duration
            self?.durationLabel.text = duration?.toDisplayString()
            
            self?.updateCurrentTimeSlider()
            
        }
    }
    
    fileprivate func updateCurrentTimeSlider() {
        
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1, 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        self.currentTimeSlider.value = Float(percentage)
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        
        
        observePlayerCurrentTime()
    
        let time = CMTimeMake(1, 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main)
        { [weak self] in
            
            print("Episode started playing...")
            self?.enlargeEpisodeImageView()
        }
    
    }
    
    static func initFromNib() -> PlayerDetailView {
        return Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)?.first as! PlayerDetailView
    }
    
    
    deinit {
        print("Deinit occurs")
        
        
    }
    
    @objc func handleTapMaximize() {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: nil)
    }
    
    //MARK:- IB Actions and IB Outlets
    
    @IBOutlet var miniEpisodeImageView: UIImageView!
    @IBOutlet var miniEpisodeLabel: UILabel!
    
    
    @IBOutlet var miniPlayPauseButton: UIButton! {
        
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    
    
    @IBOutlet var miniFastForwardButton: UIButton!
    
    
    
    
    @IBOutlet var miniPlayerView: UIView!
    @IBOutlet var maximizedStackView: UIStackView!
    
    @IBAction func handleCurrentTimeSliderChange(_ sender: Any) {
    
        guard let duration = player.currentItem?.duration else { return }
        let percentage = currentTimeSlider.value
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, Int32(NSEC_PER_SEC))
        
        player.seek(to: seekTime)
    
    }
    
    
    @IBAction func handleRewind(_ sender: Any) {
        seekToCurrentTime(delta: -15)

    }
    
    
    @IBAction func handleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    
    }
    
    fileprivate func seekToCurrentTime(delta: Int64) {
        
        let fifteenSeconds = CMTimeMakeWithSeconds(Float64(delta), Int32(NSEC_PER_SEC))
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
        
    }
    
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        
        player.volume = sender.value
    
    }
    
    @IBOutlet var currentTimeSlider: UISlider!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var currentTimeLabel: UILabel!
    
    @IBAction func handleDismiss(_ sender: Any) {
    

        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.minimizePlayerDetails()
        
    }
    
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    fileprivate func enlargeEpisodeImageView() {
    
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
    self.episodeImageView.transform = .identity
    }, completion: nil)
        
    
    }
    
    fileprivate func shrinkEpisodeImageView() {
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = self.shrunkenTransform
        }, completion: nil)
        
    }
    
    @IBOutlet var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            episodeImageView.transform = shrunkenTransform
        }
    }
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    
    @objc func handlePlayPause() {
        
        if player.timeControlStatus == .playing {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            player.pause()
            enlargeEpisodeImageView()
        } else {
             playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
             miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
             player.play()
            shrinkEpisodeImageView()
        }
    }
    
}
