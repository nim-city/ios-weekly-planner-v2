//
//  TaskItemBlock+Extensions.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-17.
//

import CoreData

extension TaskBlock {
    
    var totalHours: Int {
        Int(endHour - startHour)
    }
    
    var taskItemsList: [TaskItem] {
        taskItems?.array as? [TaskItem] ?? []
    }
    
    var category: TaskItemCategory? {
        TaskItemCategory.createTaskItemCategoryFromRawValue(string: categoryName)
    }
    
    func containsHour(_ hour: Int) -> Bool {
        hour >= Int(startHour) && hour < Int(endHour)
    }
    
    var displayValue: String? {
        
        if let name, !name.isEmpty {
            return name
        } else if let category = category?.displayValue {
            return category
        } else {
            return nil
        }
    }
}


// MARK: - Mocks


extension TaskBlock {
    
    static func createMockTaskBlock(name: String = "", category: TaskItemCategory = .chore, startHour: Int = 0, endHour: Int = 1, moc: NSManagedObjectContext) -> TaskBlock {
        
        let taskBlock = TaskBlock(context: moc)
        taskBlock.name = name
        taskBlock.startHour = Int16(startHour)
        taskBlock.endHour = Int16(endHour)
        taskBlock.categoryName = category.rawValue
        
        return taskBlock
    }
}
