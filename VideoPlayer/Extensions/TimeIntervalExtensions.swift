//
//  TimeIntervalExtensions.swift
//  VideoPlayer
//
//  Created by Vadym Piatkovskyi on 09.02.2022.
//

import Foundation

extension TimeInterval {
    
    // MARK: Public properties
    var playerHourMinuteSecond: String {
        return String(format: "%i:%02i:%02i", arguments: [hour, minute, second])
    }
    var playerMinuteSecond: String {
        return String(format: "%02i:%02i", arguments: [minute, second])
    }
    
    // MARK: Private properties
    private var hour: Int {
        return Int((self/3600).truncatingRemainder(dividingBy: 60))
    }
    
    private var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    
    private var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    
    private var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
