//
//  utilityFunctions.swift
//  dotaTracker
//
//  Created by cerdelen on 10.03.25.
//

import Foundation
import SwiftUI

//enum ID {
//    case bit32(Int32)
//    case bit64(Int64)
//}

enum SteamID {
    case bit32(Int)
    case bit64(Int)
    
    private static let offset: Int = 76_561_197_960_265_728
 
    func toBit64() -> Int {
        switch self {
            case .bit32(let value):
                return value + SteamID.offset
            case .bit64(let value):
                return value
        }
    }

    func toBit32() -> Int {
        switch self {
            case .bit32(let value):
                return value
            case .bit64(let value):
                return value - SteamID.offset
        }
    }
}


func loadHeroIcon(withID heroID: Int) -> UIImage? {
   let prefix = "\(heroID)_"
   let bundle = Bundle.main
   if let resourceURLs = bundle.urls(forResourcesWithExtension: "png", subdirectory: nil) {
       for url in resourceURLs {
           let fileName = url.lastPathComponent
           if fileName.hasPrefix(prefix) {
               return UIImage(named: fileName)
           }
       }
   }
   return nil
}

func isRadiant(playerSlot: Int) -> Bool {
    return (playerSlot & 0b10000000) == 0
}

func formatDuration(_ duration: TimeInterval) -> String {
      let minutes = Int(duration) / 60
      let seconds = Int(duration) % 60
      return String(format: "%02d:%02d", minutes, seconds)
}

func calculateBarWidth(total: CGFloat, value: Int, totalValues: Int) -> CGFloat {
        guard totalValues > 0 else { return 0 }
        return (CGFloat(value) / CGFloat(totalValues)) * total
}

// Function to convert Unix timestamp to Date
func dateFromUnixTimestamp(_ timestamp: Int) -> Date {
    return Date(timeIntervalSince1970: TimeInterval(timestamp))
}

// Function to calculate how long ago the game started
func timeAgoSince(startTime: Int) -> String {
    let startDate = dateFromUnixTimestamp(startTime)
    let calendar = Calendar.current
    let now = Date()
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate, to: now)
    
    if let year = components.year, year > 0 {
        return "\(year) year\(year == 1 ? "" : "s") ago"
    }
    if let month = components.month, month > 0 {
        return "\(month) month\(month == 1 ? "" : "s") ago"
    }
    if let day = components.day, day > 0 {
        return "\(day) day\(day == 1 ? "" : "s") ago"
    }
    if let hour = components.hour, hour > 0 {
        return "\(hour) hour\(hour == 1 ? "" : "s") ago"
    }
    if let minute = components.minute, minute > 0 {
        return "\(minute) minute\(minute == 1 ? "" : "s") ago"
    }
    if let second = components.second, second > 0 {
        return "\(second) second\(second == 1 ? "" : "s") ago"
    }
    
    return "Just now"
}
