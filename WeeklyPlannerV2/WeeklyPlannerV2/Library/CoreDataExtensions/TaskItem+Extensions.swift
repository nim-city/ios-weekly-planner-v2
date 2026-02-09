//
//  TaskItem+Extensions.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-01-29.
//

extension TaskItem {
    
    var taskItemCategory: TaskItemCategory? {
        if self is ToBuyItem {
            return .shopping
        } else if self is Meal {
            return .food
        } else if self is Workout {
            return .exercise
        } else if let toDoItem = self as? ToDoItem {
            return toDoItem.category
        } else {
            return nil
        }
    }
    
//    var weeklySchedules: Set<WeeklySchedule> {
//        
//        if let goal = self as? Goal {
//            return goal.weeklySchedules
//        }
//        
//        guard let taskBlocks = self.taskBlocks?.allObjects as? [TaskBlock] else {
//            return []
//        }
//        
//        let dailySchedules: [DailySchedule] = taskBlocks.compactMap { $0.dailySchedule }
//        let weeklySchedules = dailySchedules.compactMap { $0.weeklySchedule }
//        return Set(weeklySchedules)
//    }
}
