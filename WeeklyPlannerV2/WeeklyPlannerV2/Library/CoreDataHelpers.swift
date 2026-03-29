//
//  CoreDataHelpers.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-03-28.
//

import CoreData

class CoreDataHelpers {
    
    private init() {}
    
    static func fetchWeeklySchedule(byID id: UUID, moc: NSManagedObjectContext) -> WeeklySchedule? {
        
        let request = WeeklySchedule.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        return try? moc.fetch(request).first
    }
}
