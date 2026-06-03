//
//  DeleteCompletedTasksService.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-05-29.
//

import CoreData

// Service to delete completed tasks when a new week has begun
final class DeleteCompletedTasksService {
    
    static func deleteAllCompletedTasks(withContext context: NSManagedObjectContext) throws {
        
        // Query completed tasks
        let fetchRequest = TaskItem.fetchRequest()
        let isCompletedPredicate = NSPredicate(format: "dateCompleted != nil")
        fetchRequest.predicate = isCompletedPredicate
        
        // Fetch completed tasks
        let completedTasks = try context.fetch(fetchRequest)
        
        // Delete all tasks
        for task in completedTasks {
            context.delete(task)
        }
        
        try context.save()
    }
    
    static func deleteCompletedTasksFromPreviousWeeks(withContext context: NSManagedObjectContext) throws {
        
        // Query completed tasks
        let fetchRequest = TaskItem.fetchRequest()
        let isCompletedPredicate = NSPredicate(format: "dateCompleted != nil")
        fetchRequest.predicate = isCompletedPredicate
        
        // Fetch completed tasks
        let completedTasks = try context.fetch(fetchRequest)
        
        // Delete tasks completed last week
        let currentWeek = Calendar.current.component(.weekOfYear, from: Date())
        for task in completedTasks {
            
            guard let dateCompleted = task.dateCompleted else { continue }
            let weekCompleted = Calendar(identifier: .iso8601).component(.weekOfYear, from: dateCompleted)
            if weekCompleted < currentWeek {
                context.delete(task)
            }
        }
        
        try context.save()
    }
}
