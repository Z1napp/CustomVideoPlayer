//
//  TimeIntervalExtensions.swift
//  VideoPlayer
//
//  Created by Vadym Piatkovskyi on 09.02.2022.
//

import Foundation

extension TimeInterval {
    var playerHourMinuteSecond: String {
        return String(format: "%i:%02i:%02i", arguments: [hour, minute, second])
    }
    var playerMinuteSecond: String {
        return String(format: "%02i:%02i", arguments: [minute, second])
    }
    
    var hour: Int {
        return Int((self/3600).truncatingRemainder(dividingBy: 60))
    }
    
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
