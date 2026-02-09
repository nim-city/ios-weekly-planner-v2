//
//  ToDoItem+Extensions.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-19.
//

import CoreData


extension ToDoItem {
    
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
    
    var category: TaskItemCategory? {
        
        guard let categoryName else { return nil }
        return TaskItemCategory(rawValue: categoryName)
    }
}


// MARK: - Mocks


extension ToDoItem {
    
    static func createMockToDoItem(name: String = "", category: TaskItemCategory = .chore, priority: TaskItemPriority = .low, recurring: Bool = false, completed: Bool = false, createdAt: Date = Date(), notes: String = "", moc: NSManagedObjectContext) -> ToDoItem {
        
        let toDoItem = ToDoItem(context: moc)
        toDoItem.name = name
        toDoItem.categoryName = category.rawValue
        toDoItem.priority = priority.rawValue
        toDoItem.recurring = recurring
        toDoItem.completed = completed
        toDoItem.createdAt = createdAt
        toDoItem.notes = notes
        
        return toDoItem
    }
}
