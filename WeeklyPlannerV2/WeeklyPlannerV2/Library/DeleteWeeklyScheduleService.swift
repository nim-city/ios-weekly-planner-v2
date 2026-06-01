//
//  DeleteWeeklyScheduleService.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-05-31.
//

import CoreData

final class DeleteWeeklyScheduleService {
    
    static func deleteWeeklySchedule(_ weeklySchedule: WeeklySchedule, withContext context: NSManagedObjectContext) throws {
        
        // Delete daily schedules
        for dailySchedule in weeklySchedule.dailySchedulesList {
            
            // Delete task blocks
            for taskBlock in dailySchedule.taskBlocksList {
                context.delete(taskBlock)
            }
            
            // No need to delete task items themselves
            
            // Delete daily schedule
            context.delete(dailySchedule)
        }
        
        // Delete weekly schedule
        context.delete(weeklySchedule)
        
        try context.save()
    }
}
