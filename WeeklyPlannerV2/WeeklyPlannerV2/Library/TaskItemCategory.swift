//
//  TaskItemCategory.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-06.
//

import Foundation

enum TaskItemCategory: String, CaseIterable {
    
    case chore
    case exercise
    case food
    case leisure
    case routine
    case shopping
    case study
    case work
    
    static var toDoItemCategories: [TaskItemCategory] = [
        .chore,
        .leisure,
        .routine,
        .study,
        .work
    ]
    
    static var defaultCategory: TaskItemCategory {
        .chore
    }
    
    var displayValue: String {
        self.rawValue
    }
    
    var imageName: String {
        switch self {
        case .chore:
            return "washer"
        case .exercise:
            return "dumbbell.fill"
        case .food:
            return "fork.knife"
        case .leisure:
            return "moon.zzz.fill"
        case .routine:
            return "person.badge.clock.fill"
        case .shopping:
            return "cart.fill"
        case .study:
            return "book.fill"
        case .work:
            return "desktopcomputer.and.macbook"
        }
    }
    
    var taskItemType: TaskItemType {
        switch self {
        case .chore, .leisure, .routine, .study, .work:
            return .toDoItem
        case .exercise:
            return .workout
        case .food:
            return .meal
        case .shopping:
            return .toBuyItem
        }
    }
    
    static func createToDoItemFromRawValue(string: String?) -> TaskItemCategory? {
        TaskItemCategory.toDoItemCategories.first(where: { $0.rawValue == string })
    }
    
    static func createTaskItemCategoryFromRawValue(string: String?) -> TaskItemCategory? {
        TaskItemCategory.allCases.first(where: { $0.rawValue == string })
    }
}
