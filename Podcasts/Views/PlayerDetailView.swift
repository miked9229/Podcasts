//
//  PlayersDetailView.swift
//  Podcasts
//
//  Created by Michael Doroff on 7/23/18.
//  Copyright © 2018 Michael Doroff. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class PlayerDetailView: UIView {
    
    var episode: Episode! {
        didSet {
            miniEpisodeLabel.text = episode.title
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            
            setupNowPlayingInfo()
            setupAudioSession()
            PlayEpisode()

            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            
            episodeImageView.sd_setImage(with: url)
            
            miniEpisodeImageView.sd_setImage(with: url) { (image, _, _, _) in
        
                let image = self.episodeImageView.image ?? UIImage()
                
                let artwork = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { (size) -> UIImage in
                    
                    return image
                })
            
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork

            }

        }
        
    }
    
    
    fileprivate func  setupNowPlayingInfo() {
        
        var nowPlayingInfo = [String: Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
    }
    
    
    public func PlayEpisode() {
        
        if episode.fileUrl != nil {
            
            playEpisodeUsingFileUrl()
            
        } else {
            
            guard let url = URL(string: episode.streamUrl ?? "") else { return }
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()
            
        }
        
        
    }
    
    private func playEpisodeUsingFileUrl() {
        print("Attempting to play epsiode with fileUrl:", episode.fileUrl ?? "")
        
        guard let fileURL = URL(string: episode.fileUrl ?? "") else { return }
        
        let fileName = fileURL.lastPathComponent
        
        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        trueLocation.appendPathComponent(fileName)
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    fileprivate func observePlayerCurrentTime() {
       
        let interval = CMTimeMake(value: 1,timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            let duration = self?.player.currentItem?.duration
            self?.durationLabel.text = duration?.toDisplayString()
            
            self?.updateCurrentTimeSlider()
            
        }
    }
    
    
    fileprivate func updateCurrentTimeSlider() {
        
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        self.currentTimeSlider.value = Float(percentage)
    
    }
    
    var panGesture: UIPanGestureRecognizer!
    
    fileprivate func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)
        
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
    
        if gesture.state == .changed {
            let translation = gesture.translation(in: self.superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.maximizedStackView.transform = .identity
                
                if translation.y > 50 {
                    
                    UIApplication.mainTabBarController()?.minimizePlayerDetails()
                }
            
            })
            
            
        }
        
    }
    
    fileprivate func setupAudioSession() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)))
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch let SessionErr {
            print("Failed to activate session: ",  SessionErr)
        }
        
    }
    
    fileprivate func setupRemoteControl() {
    
    UIApplication.shared.beginReceivingRemoteControlEvents()
    
    let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.player.play()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.setupElapsedTime(playbackRate: 1)
            return .success
        }
    
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.player.pause()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.setupElapsedTime(playbackRate: 0)
            return .success
        }
     
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.handlePlayPause()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleNextTrack))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(handlePreviousTrack))
        
        
    }
    
    var playlistEpisodes = [Episode]()
    
    

    @objc fileprivate func handlePreviousTrack() {

        if playlistEpisodes.count == 0 {
            return
        }
        
        let currentEpisodeIndex = playlistEpisodes.firstIndex { (ep) -> Bool in
            return self.episode.title == ep.title
        }
        
        guard let index = currentEpisodeIndex else { return }
        
        let previousEpisode: Episode
        if index == 0 {
            previousEpisode = playlistEpisodes[playlistEpisodes.count - 1 ]
            
        } else {
            previousEpisode = playlistEpisodes[index - 1]
        }
        
        self.episode = previousEpisode
    
    }
    
    @objc fileprivate func handleNextTrack() {

        if playlistEpisodes.count == 0 {
            return
        }
    
        let currentEpisodeIndex = playlistEpisodes.firstIndex { (ep) -> Bool in
            return self.episode.title == ep.title
        }
        
        
     guard let index = currentEpisodeIndex else { return }

        let nextEpisode: Episode
        if index == playlistEpisodes.count - 1 {
            nextEpisode = playlistEpisodes[0]
            
        } else {
            nextEpisode = playlistEpisodes[index + 1]
        }

        self.episode = nextEpisode
    }
    
    fileprivate func setupElapsedTime(playbackRate: Float) {
        
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
        
    }
    
    fileprivate func observeBoundaryTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main)
        { [weak self] in
            
            print("Episode started playing...")
            self?.enlargeEpisodeImageView()
            self?.setupLockscreenDuration()
        }
    }
    
    fileprivate func setupLockscreenDuration() {
        
        guard let duration = player.currentItem?.duration else { return }
        
        let durationSeconds = CMTimeGetSeconds(duration)
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
        
    }
    
    fileprivate func setupInterruptionObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc fileprivate func handleInterruption(notification: NSNotification) {
        
        print("Interruption Observation observed...")
        
        
        guard let userInfo = notification.userInfo else { return }
        
        
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        
        if type == AVAudioSession.InterruptionType.began.rawValue {
            
            print("Interruption began....")
            
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            
            
        } else {
            
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                
                player.play()
                playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                
            }
            
            print("Interruption ended...")

        
        }
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        setupRemoteControl()
        setupGestures()
        observePlayerCurrentTime()
        setupInterruptionObserver()
        observeBoundaryTime()
    
    }

    
    static func initFromNib() -> PlayerDetailView {
        return Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)?.first as! PlayerDetailView
    }
    
    deinit {
        print("Deinit occurs")
        
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
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        
        player.seek(to: seekTime)
    
    }
    
    @IBAction func handleRewind(_ sender: Any) {
        seekToCurrentTime(delta: -15)

    }
    
    
    @IBAction func handleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    
    }
    
    fileprivate func seekToCurrentTime(delta: Int64) {
        
        let fifteenSeconds = CMTimeMakeWithSeconds(Float64(delta), preferredTimescale: Int32(NSEC_PER_SEC))
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
    
        UIApplication.mainTabBarController()?.minimizePlayerDetails()
        
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
            setupElapsedTime(playbackRate: 1)
            
        } else {
             playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
             miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
             player.play()
            shrinkEpisodeImageView()
            setupElapsedTime(playbackRate: 0)
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
