//
//  UXControlButton.swift
//  VideoPlayer
//
//  Created by Vadym Piatkovskyi on 09.02.2022.
//

import UIKit

enum PlayerControlButton {
    case previousVideo
    case seekBackward
    case playPause
    case seekForward
    case nextVideo
}

private enum uiConstants {
    static let cornerRadius: CGFloat = 4
}

class UXControlButton: UIButton {
    var type: PlayerControlButton = .playPause {
        didSet {
            refreshAppearance()
        }
    }
    
    var isPlaying: Bool = false {
        didSet {
            refreshAppearance()
        }
    }
    
    // MARK: Init View
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
}


// MARK: Private methods
private extension UXControlButton {
    func setup() {
        backgroundColor    = UIColor.Theme.accent
        tintColor          = UIColor.Theme.white
        
        setTitle("", for : .normal)
        
        applyWhiteShadow(cornerRadius: uiConstants.cornerRadius)
        
    }
    
    func refreshAppearance() {
        setImage(type.icon(isPlaying), for: .normal)
    }
}

private extension PlayerControlButton {
    func icon(_ isPlaying: Bool = false) -> UIImage? {
        switch self {
        case .previousVideo:
            return UIImage.Controls.previousVideo
        case .seekBackward:
            return UIImage.Controls.seekBackward
        case .playPause:
            return isPlaying ? UIImage.Controls.pause : UIImage.Controls.play
        case .seekForward:
            return UIImage.Controls.seekForward
        case .nextVideo:
            return UIImage.Controls.nextVideo
        }
    }
}
