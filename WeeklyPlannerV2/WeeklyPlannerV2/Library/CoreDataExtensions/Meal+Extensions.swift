//
//  Meal+Extensions.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-18.
//

import CoreData

extension Meal {
    
    var dailySchedulesList: [DailySchedule] {
        
        // Get currently selected weekly schedule if it exists
        guard let currentWeeklyScheduleId = Preferences.shared.getSelectedWeeklyScheduleID() else { return [] }
        
        // Get task item blocks and through them
        guard let taskBlocks = self.taskBlocks?.sortedArray(using: []) as? [TaskBlock] else { return [] }
        
        // Get weekdays of daily schedules to which task item blocks belong
        let dailySchedules = taskBlocks.compactMap { $0.dailySchedule }
        
        // Filter daily schedules belonging to current weekly schedule
        return dailySchedules.filter {
            
            guard let weeklySchedule = $0.weeklySchedule else { return false }
            return weeklySchedule.id?.uuidString == currentWeeklyScheduleId
        }
    }
}


// MARK: - Mocks


extension Meal {
    
    static func createMockMeal(name: String = "", category: MealCategory = .breakfast, completed: Bool = false, createdAt: Date = Date(), notes: String = "", moc: NSManagedObjectContext) -> Meal {
        
        let meal = Meal(context: moc)
        meal.name = name
        meal.categoryName = category.rawValue
        meal.completed = completed
        meal.createdAt = createdAt
        meal.notes = notes
        
        return meal
    }
}
