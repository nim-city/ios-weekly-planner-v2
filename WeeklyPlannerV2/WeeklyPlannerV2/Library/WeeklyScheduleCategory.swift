//
//  WeeklyScheduleCategory.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-07.
//

import Foundation

enum WeeklyScheduleCategory: String, CaseIterable {
    
    case holiday
    case hybrid
    case work
    
    var displayName: String {
        self.rawValue.capitalized
    }
    
    var weekTypeLabel: String {
        switch self {
        case .holiday:
            return "Holiday week"
        case .hybrid:
            return "Hybrid work week"
        case .work:
            return "Work week"
        }
    }
    
    static func createFromString(rawValue: String) -> WeeklyScheduleCategory? {
        WeeklyScheduleCategory.allCases.first(where: { $0.rawValue == rawValue })
    }
}
