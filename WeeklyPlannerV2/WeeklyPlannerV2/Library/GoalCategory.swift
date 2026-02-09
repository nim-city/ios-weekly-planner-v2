//
//  GoalCategory.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-06.
//

import Foundation

enum GoalCategory: String, CaseIterable, Identifiable {
    
    // Order chronologically rather than alphabetically
    case daily
    case weekly
    case longTerm = "long_term"
    
    var id: Self {
        self
    }
    
    var displayValue: String {
        switch self {
        case .daily:
            return "daily"
        case .longTerm:
            return "long term"
        case .weekly:
            return "weekly"
        }
    }
    
    static func createFromRawValue(string: String?) -> GoalCategory? {
        GoalCategory.allCases.first(where: { $0.rawValue == string })
    }
}
