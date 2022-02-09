//
//  UXImage.swift
//  VideoPlayer
//
//  Created by Vadym Piatkovskyi on 09.02.2022.
//

import Foundation
import UIKit

extension UIImage {
    enum Slider {
        static let minimumTrack = UIImage(named : "slideMinimum")
        static let maximumTrack = UIImage(named : "slideMaximum")
        static let thumb        = UIImage(named : "sliderThumb")
    }
    
    enum Controls {
        static let previousVideo = UIImage(systemName : "backward.end.fill")
        static let seekBackward  = UIImage(systemName : "backward.fill")
        static let play          = UIImage(systemName : "play.fill")
        static let pause         = UIImage(systemName : "pause.fill")
        static let seekForward   = UIImage(systemName : "forward.fill")
        static let nextVideo     = UIImage(systemName : "forward.end.fill")
    }
}
