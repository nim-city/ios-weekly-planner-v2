//
//  MealCategory.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-13.
//

import Foundation

enum MealCategory: String, CaseIterable {
    
    // Order chronologically instead of alphabetically
    case breakfast
    case lunch
    case dinner
    case snack
    
    var displayValue: String {
        return rawValue
    }
    
    var pluralDisplayValue: String {
        self == .lunch ? "lunches" : "\(displayValue)s"
    }
    
    static func createFromRawValue(string: String?) -> MealCategory? {
        MealCategory.allCases.first(where: { $0.rawValue == string })
    }
}
