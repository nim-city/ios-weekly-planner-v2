//
//  AppColours.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-17.
//

import SwiftUI

class AppColours {
    
    private init() {}
    
    static let appTheme: Color = .init(red: 7/255, green: 88/255, blue: 112/255)
    static let darkGray: Color = .init(red: 75/255, green: 75/255, blue: 75/255)
    static let offBlack: Color = .init(red: 55/255, green: 55/255, blue: 55/255)
    static let offWhite: Color = .init(red: 220/255, green: 220/255, blue: 220/255)
    static let lightShadowColour: Color = .init(red: 210/255, green: 210/255, blue: 210/255)
    static let shadowColour: Color = .init(red: 155/255, green: 155/255, blue: 155/255)
    static let subduedText: Color = .init(red: 100/255, green: 100/255, blue: 100/255)
    static let subtleDivider: Color = .init(red: 200/255, green: 200/255, blue: 200/255)
    static let dividerBold: Color = .init(red: 100/255, green: 100/255, blue: 100/255)
    // Borders
    static let borderSubdued: Color = .init(red: 220/255, green: 220/255, blue: 220/255)
    
    static func getColourForTaskItemCategory(_ category: TaskItemCategory) -> Color {
        
        switch category {
        case .chore:
            return .chore
        case .exercise:
            return .exercise
        case .food:
            return .food
        case .leisure:
            return .leisure
        case .routine:
            return .routine
        case .shopping:
            return .shopping
        case .study:
            return .study
        case .work:
            return .work
        }
    }
    
    static func getColourForTaskItemBlock(_ taskBlock: TaskBlock) -> Color {
        
        guard let category = TaskItemCategory.createTaskItemCategoryFromRawValue(string: taskBlock.categoryName) else {
            return .white
        }
        
        return getColourForTaskItemCategory(category)
    }
    
    static func getDarkColourForTaskItemType(_ type: TaskItemType) -> Color {
        
        switch type {
        case .goal:
            return .goalDarkened
        case .toDoItem:
            return .toDoItemDarkened
        case .workout:
            return .workoutDarkened
        case .meal:
            return .mealDarkened
        case .toBuyItem:
            return .toBuyItemDarkened
        }
    }
    
    static func getColourForTaskItemType(_ type: TaskItemType) -> Color {

        switch type {
        case .goal:
            return .goal
        case .toDoItem:
            return .toDoItem
        case .workout:
            return .workout
        case .meal:
            return .meal
        case .toBuyItem:
            return .toBuyItem
        }
    }
    
    static func getColourForWeeklySchedule(_ weeklySchedule: WeeklySchedule?) -> Color {
        
        guard let weeklySchedule, let colourData = weeklySchedule.colourData else { return appTheme }
        
        return Color.decodeFromData(colourData) ?? appTheme
    }
}
