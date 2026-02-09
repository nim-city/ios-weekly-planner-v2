//
//  TaskItemPriority.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-06.
//

import Foundation

enum TaskItemPriority: Int16, CaseIterable {
    
    // Order by severity instead of alphabetically
    case high = 1
    case moderate = 2
    case low = 3
    
    var displayValue: String {
        switch self {
        case .high:
            "high"
        case .moderate:
            "moderate"
        case .low:
            "low"
        }
    }
    
    static func createFromRawValue(int: Int16?) -> TaskItemPriority? {
        TaskItemPriority.allCases.first(where: { $0.rawValue == int })
    }
}
