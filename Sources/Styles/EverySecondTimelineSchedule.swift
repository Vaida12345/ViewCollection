//
//  EverySecondTimelineSchedule.swift
//  FinderQuery
//
//  Created by Vaida on 2025-05-05.
//

import SwiftUI


public struct EverySecondTimelineSchedule: TimelineSchedule {
    
    public func entries(from startDate: Date, mode: Mode) -> UnfoldSequence<Date, (Date?, Bool)> {
        sequence(first: startDate) { date in
            date.addingTimeInterval(mode == .normal ? 1 : 60)
        }
    }
    
}


public extension TimelineSchedule where Self == EverySecondTimelineSchedule {
    
    static var everySecond: EverySecondTimelineSchedule {
        EverySecondTimelineSchedule()
    }
    
}
