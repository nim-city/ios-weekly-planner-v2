//
//  Weekday.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-06.
//

import Foundation

enum Weekday: Int, CaseIterable, Identifiable {
    
    case monday = 0
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var id: Int {
        self.rawValue
    }
    
    var displayName: String {
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
    
    var shortName: String {
        String(displayName.prefix(2))
    }
    
    var initial: String {
        String(displayName.prefix(1))
    }
    
    static func createFromRawValue(_ rawValue: Int) -> Weekday? {
        Weekday.allCases.first(where: { $0.rawValue == rawValue })
    }
}
