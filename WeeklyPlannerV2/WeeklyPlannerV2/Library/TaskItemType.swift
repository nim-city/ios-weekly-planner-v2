//
//  TaskItemType.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-08.
//

import Foundation

enum TaskItemType: String, CaseIterable {
    
    // Ordered by usage instead of alphabetically
    case goal
    case toDoItem = "to_do_item"
    case workout
    case meal
    case toBuyItem = "to_buy_item"
    
    var displayValue: String {
        switch self {
        case .goal:
            return "goal"
        case .meal:
            return "meal"
        case .toBuyItem:
            return "to buy item"
        case .toDoItem:
            return "to do item"
        case .workout:
            return "workout"
        }
    }
    
    var shortDisplayValue: String {
        switch self {
        case .goal:
            return "Goal"
        case .meal:
            return "Meal"
        case .toBuyItem:
            return "To Buy"
        case .toDoItem:
            return "To Do"
        case .workout:
            return "Workout"
        }
    }
}
