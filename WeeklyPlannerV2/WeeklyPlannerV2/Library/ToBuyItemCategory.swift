//
//  ToBuyItemCategory.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-04-03.
//

enum ToBuyItemCategory: String, CaseIterable {
    
    case forMe
    case forOthers
    
    var displayValue: String {
        switch self {
        case .forMe:
            return "Personal"
        case .forOthers:
            return "For Others"
        }
    }
    
    static func createFromRawValue(name: String?) -> ToBuyItemCategory? {
        ToBuyItemCategory.allCases.first(where: { $0.rawValue == name })
    }
}
