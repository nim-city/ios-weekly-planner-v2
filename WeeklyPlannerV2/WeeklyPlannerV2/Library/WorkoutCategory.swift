//
//  WorkoutCategory.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-05-09.
//

enum WorkoutCategory: String, CaseIterable, Identifiable {
    
    case cardio
    case hiit
    case sport
    case strength
    
    var id: String {
        self.rawValue
    }
    
    var displayValue: String {
        self.rawValue
    }
    
    static func createFromRawValue(string: String?) -> WorkoutCategory? {
        WorkoutCategory.allCases.first(where: { $0.rawValue == string })
    }
}
