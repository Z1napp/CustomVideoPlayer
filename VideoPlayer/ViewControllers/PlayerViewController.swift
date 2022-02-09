//
//  PlayerViewController.swift
//  VideoPlayer
//
//  Created by Vadym Piatkovskyi on 09.02.2022.
//

import UIKit

import AVFoundation

private enum VideoURLS {
    static let space = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")! //"https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1280_10MG.mp4")!
}

private enum Constants {
    static let seekStep: Double = 2
    static let duration = "duration"
}

class PlayerViewController: UIViewController {
 
    // MARK: - IBOutlets
    @IBOutlet weak private var videoContainerView    : UIView!
    @IBOutlet weak private var controlsView          : UXPlayerControlsView!
    @IBOutlet weak private var gradientContainerView : UIView!
    
    // MARK: - Private properties
    private var player              : AVPlayer?
    private var playerLayer         : AVPlayerLayer?
    private var currentTimeObserver : Any?
    private var currentVideoIndex   : Int = .zero {
        didSet {
            performAnotherVideo()
        }
    }
    
    private var gradientLayer: CAGradientLayer?
    
    private var videoData = [VideoURLS.space,
                             VideoURLS.space,
                             VideoURLS.space,
                             VideoURLS.space]
    
    // MARK: - Lifecycle && override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer?.frame = gradientContainerView.bounds
        playerLayer?.frame = videoContainerView.bounds
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Constants.duration,
           let duration = player?.currentItem?.duration.seconds,
           duration > .zero {
            
            controlsView.totalTimeString = getTimeString(from: player?.currentItem?.duration ?? .zero)
        }
    }
    
    // MARK: - Public methods
    func setup(videos: [URL]) {
        self.videoData = videos
    }
}

// MARK: - Private methods
private extension PlayerViewController {
    func setup() {
        func setupBackgrounds() {
            view.backgroundColor = UIColor.Theme.background
            videoContainerView.backgroundColor = .clear
        }
        
        func setupControlsView() {
            controlsView.previousVideoTap = { [weak self] in
                guard let self = self else { return }
                
                self.currentVideoIndex > 0
                ? self.currentVideoIndex -= 1
                : nil
            }
            
            controlsView.backwardTap = { [weak self] in
                guard let self = self else { return }
                
                self.seek(isForward: false)
            }
            
            controlsView.playPauseTap = { [weak self] shouldPlay in
                guard let self = self else { return }
                
                shouldPlay
                ? self.player?.play()
                : self.player?.pause()
            }
            
            controlsView.forwardTap = { [weak self] in
                guard let self = self else { return }
                
                self.seek(isForward: true)
            }
            
            controlsView.nextVideoTap = { [weak self] in
                guard let self = self else { return }
                
                self.currentVideoIndex < self.videoData.count - 1
                ? self.currentVideoIndex += 1
                : nil
            }
            
            controlsView.onSliderValueChange = { [weak self] sliderValue in
                guard let self = self else { return }
                self.player?.seek(to: CMTime(value: Int64(sliderValue * 1000), timescale: 1000))
            }
            
            controlsView.shouldHideNextPreviousButtons = videoData.isEmpty || videoData.count <= 1
        }
        
        func setupGradientLayer() {
            gradientContainerView.backgroundColor = .clear
            gradientContainerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            gradientLayer = CAGradientLayer()
            gradientLayer?.frame = gradientContainerView.bounds
            gradientLayer?.colors = [UIColor.clear.cgColor, UIColor.Theme.accent.cgColor]
            gradientLayer?.locations = [0.0, 1.0]
            
            guard let gradientLayer = gradientLayer else { return }
            gradientContainerView.layer.addSublayer(gradientLayer)
        }
        
        setupGradientLayer()
        addDidFinishObserver()
        setupBackgrounds()
        setupControlsView()
        performAnotherVideo()
    }
    
    // MARK: Player
    func performAnotherVideo() {
        func destroyPlayer() {
            player?.pause()
            controlsView.isPlayingVideo = false
            controlsView.sliderCurrentValue = 0
            controlsView.currentTimeString = Double(0).playerMinuteSecond
            
            if let timeObserver = currentTimeObserver {
                player?.removeTimeObserver(timeObserver)
            }
            player?.currentItem?.removeObserver(self, forKeyPath: Constants.duration, context: nil)
            
            player = nil
            playerLayer?.removeFromSuperlayer()
            playerLayer = nil
        }
        
        func refreshLeftRightButtons() {
            controlsView.shouldDisablePrevious = currentVideoIndex == .zero
            controlsView.shouldDisableNext = currentVideoIndex == videoData.count - 1
        }
        
        destroyPlayer()
        
        guard let videoURL = videoData[safe: currentVideoIndex] else { return }
        setupPlayer(with: videoURL)
        refreshLeftRightButtons()
    }
    
    func setupPlayer(with videoURL: URL) {
        player = AVPlayer(url: videoURL)
        
        addCurrentTimeObserver()
        addDurationObserver()
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        
        guard let playerLayer = playerLayer else { return }
        videoContainerView.layer.addSublayer(playerLayer)
    }
    
    func seek(isForward: Bool) {
        guard let duration = player?.currentItem?.duration else { return }
        let currentTime = CMTimeGetSeconds(player?.currentTime() ?? .zero)
        var newTime = Float64(isForward
                              ? currentTime + Constants.seekStep
                              : currentTime - Constants.seekStep)
        
        
        if isForward {
            if newTime < CMTimeGetSeconds(duration) - Constants.seekStep {
                let time = CMTime(value: Int64(newTime * 1000), timescale: 1000)
                player?.seek(to: time)
            }
        } else {
            
            if newTime < 0 {
                newTime = 0
            }
            let time = CMTime(value: Int64(newTime * 1000), timescale: 1000)
            player?.seek(to: time)
        }
    }
    
    // MARK: Observers
    func addCurrentTimeObserver() {
        let interval = CMTime(value: CMTimeValue(33), timescale: 1000)
        currentTimeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time in
            guard let self = self else { return }
            guard let currentItem = self.player?.currentItem else { return }
            
            self.controlsView.sliderMaxValue     = Float(currentItem.duration.seconds)
            self.controlsView.sliderMinValue     = .zero
            self.controlsView.sliderCurrentValue = Float(currentItem.currentTime().seconds)
            self.controlsView.currentTimeString = self.getTimeString(from: currentItem.currentTime())
        })
    }
    
    func addDurationObserver() {
        player?.currentItem?.addObserver(self,
                                         forKeyPath : Constants.duration,
                                         options    : [.new, .initial],
                                         context    : nil)
    }
    
    func addDidFinishObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidFinished),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    // MARK: Additional
    func getTimeString(from time: CMTime) -> String {
        let totalSec = Double(CMTimeGetSeconds(time))
        let hours = totalSec.hour
        
        return hours > 0
        ? totalSec.playerHourMinuteSecond
        : totalSec.playerMinuteSecond
    }
}

// MARK: Actions
private extension PlayerViewController {
    @objc
    func videoDidFinished() {
        controlsView.isPlayingVideo = false
    }
}
