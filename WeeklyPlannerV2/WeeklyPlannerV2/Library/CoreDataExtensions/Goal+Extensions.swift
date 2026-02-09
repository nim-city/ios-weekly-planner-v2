//
//  Goal+Extensions.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-13.
//

import CoreData

extension Goal {
    
    var category: GoalCategory? {
        GoalCategory.createFromRawValue(string: categoryName)
    }
    
    var weeklySchedulesList: [WeeklySchedule] {
        weeklySchedules?.sortedArray(using: []) as? [WeeklySchedule] ?? []
    }
    
    var weekdaysCompleted: [Weekday] {
        
        guard let weekdaysCompletedIndices else { return [] }
        return weekdaysCompletedIndices.compactMap {
            Weekday(rawValue: Int($0))
        }
    }
    
    func updateWeekdaysCompleted(to weekdays: [Weekday]) {
        
        let indices = weekdays.map { Int16($0.rawValue) }
        weekdaysCompletedIndices = indices
    }
}


// MARK: - Mocks


extension Goal {
    
    static func createMockGoal(name: String = "", category: GoalCategory = .daily, completed: Bool = false, createdAt: Date = Date(), notes: String = "", moc: NSManagedObjectContext) -> Goal {
        
        let goal = Goal(context: moc)
        goal.name = name
        goal.categoryName = category.rawValue
        goal.completed = completed
        goal.createdAt = createdAt
        goal.notes = notes
        
        return goal
    }
}
