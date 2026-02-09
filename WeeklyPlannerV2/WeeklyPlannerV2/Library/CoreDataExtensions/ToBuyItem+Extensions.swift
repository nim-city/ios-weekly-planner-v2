//
//  ToBuyItem+Extensions.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-19.
//

import CoreData


extension ToBuyItem {
    
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


extension ToBuyItem {
    
    static func createMockToBuyItem(name: String = "", priority: TaskItemPriority = .low, completed: Bool = false, createdAt: Date = Date(), notes: String = "", moc: NSManagedObjectContext) -> ToBuyItem {
        
        let toBuyItem = ToBuyItem(context: moc)
        toBuyItem.name = name
        toBuyItem.priority = Int16(priority.rawValue)
        toBuyItem.completed = completed
        toBuyItem.createdAt = createdAt
        toBuyItem.notes = notes
        
        return toBuyItem
    }
}
