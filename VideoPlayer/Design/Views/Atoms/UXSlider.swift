//
//  UXSlider.swift
//  VideoPlayer
//
//  Created by Vadym Piatkovskyi on 09.02.2022.
//

import Foundation
import UIKit

private enum uiConstants {
    static let sliderHeight: CGFloat = 5
}

class UXSlider: UISlider {
    // MARK: Init View
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    // MARK: Override methods
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
        result.origin.x    = .zero
        result.size.width  = bounds.size.width
        result.size.height = uiConstants.sliderHeight
        return result
    }

    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return super.thumbRect(forBounds:
            bounds, trackRect: rect, value: value)
            .offsetBy(dx: .zero, dy: .zero)
    }
    
}

// MARK: Private methods
private extension UXSlider {
    func setup() {
        setMinimumTrackImage(UIImage.Slider.minimumTrack, for: .normal)
        setMaximumTrackImage(UIImage.Slider.maximumTrack, for: .normal)
        setThumbImage(UIImage.Slider.thumb, for: .normal)
    }
}
