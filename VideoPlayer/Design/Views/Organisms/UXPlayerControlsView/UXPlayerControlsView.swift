//
//  UXPlayerControlsView.swift
//  LTRecording
//
//  Created by Vadym Piatkovskyi on 08.02.2022.
//  Copyright © 2022 Latest Thinking GmbH. All rights reserved.
//

import Foundation
import UIKit

private enum uiConstants {
    static let customSpacing: CGFloat = 40
}

class UXPlayerControlsView: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak private var slider              : UXSlider!
    @IBOutlet weak private var currentTimeLabel    : UILabel!
    @IBOutlet weak private var totalTimeLabel      : UILabel!
    @IBOutlet weak private var controlStackView    : UIStackView!
    @IBOutlet weak private var previousVideoButton : UXControlButton!
    @IBOutlet weak private var seekBackwardButton  : UXControlButton!
    @IBOutlet weak private var playPauseButton     : UXControlButton!
    @IBOutlet weak private var seekForwardButton   : UXControlButton!
    @IBOutlet weak private var nextVideoButton     : UXControlButton!
    
    
    // MARK: Public properties
    var isPlayingVideo: Bool = false {
        didSet {
            refreshPlayPauseButton()
        }
    }
    
    var totalTimeString = Double(0).playerMinuteSecond {
        didSet {
            totalTimeLabel.text = totalTimeString
        }
    }
    var currentTimeString = Double(0).playerMinuteSecond  {
        didSet {
            currentTimeLabel.text = currentTimeString
        }
    }
    
    var sliderMinValue: Float = .zero {
        didSet {
            slider.minimumValue = sliderMinValue
        }
    }
    
    var sliderMaxValue: Float = .zero {
        didSet {
            slider.maximumValue = sliderMaxValue
        }
    }
    
    var sliderCurrentValue: Float = .zero {
        didSet {
            slider.value = sliderCurrentValue
        }
    }
    
    var shouldDisablePrevious: Bool = false {
        didSet {
            previousVideoButton.isEnabled = !shouldDisablePrevious
        }
    }
    
    var shouldDisableNext: Bool = false {
        didSet {
            nextVideoButton.isEnabled = !shouldDisableNext
        }
    }
    
    var shouldHideNextPreviousButtons: Bool = false {
        didSet {
            [previousVideoButton, nextVideoButton]
                .forEach({ $0?.isHidden =  shouldHideNextPreviousButtons })
        }
    }
    
    var previousVideoTap    : ReturnAction?,
        backwardTap         : ReturnAction?,
        playPauseTap        : ReturnFlag?,
        forwardTap          : ReturnAction?,
        nextVideoTap        : ReturnAction?,
        onSliderValueChange : ReturnFloat?
    
    // MARK: - View initializing
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        subviewFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        subviewFromNib()
        setup()
    }
}


// MARK: - Actions
private extension UXPlayerControlsView {
    @IBAction func sliderValueChangeAction(_ sender: UXSlider) {
        onSliderValueChange?(sender.value)
    }
    
    @IBAction func previousButtonAction() {
        previousVideoTap?()
    }
    
    @IBAction func seekBackwardButtonAction() {
        backwardTap?()
    }
    
    @IBAction func playPauseButtonAction() {
        isPlayingVideo.toggle()
        playPauseTap?(isPlayingVideo)
    }
    
    @IBAction func seekForwardButtonAction() {
        forwardTap?()
    }
    
    @IBAction func nextVideoButtonAction() {
        nextVideoTap?()
    }
}

// MARK: - Private methods
private extension UXPlayerControlsView {
    func setup() {
        func setupLabels() {
            [currentTimeLabel, totalTimeLabel].forEach({
                $0?.textColor = UIColor.Theme.accent
                $0?.font      = UIFont.systemFont(ofSize: 12)
                $0?.text      = "0:00"
                $0?.applyWhiteShadow()
            })
            
            currentTimeLabel.textAlignment   = .left
            totalTimeLabel.textAlignment = .right
        }
        
        func setupButtons() {
            previousVideoButton.type = .previousVideo
            seekBackwardButton.type  = .seekBackward
            playPauseButton.type     = .playPause
            seekForwardButton.type   = .seekForward
            nextVideoButton.type     = .nextVideo
            
            refreshPlayPauseButton()
        }
        
        func setupStackView() {
            controlStackView.axis = .horizontal
            controlStackView.distribution = .equalCentering
            controlStackView.setCustomSpacing(uiConstants.customSpacing, after: seekBackwardButton)
            controlStackView.setCustomSpacing(uiConstants.customSpacing, after: playPauseButton)
        }
        
        func setupSlider() {
            slider.value = sliderCurrentValue
        }
        
        backgroundColor = .clear
        superview?.backgroundColor = .clear
        
        setupLabels()
        setupButtons()
        setupStackView()
    }
    
    func refreshPlayPauseButton() {
        playPauseButton.isPlaying = isPlayingVideo
    }
}
