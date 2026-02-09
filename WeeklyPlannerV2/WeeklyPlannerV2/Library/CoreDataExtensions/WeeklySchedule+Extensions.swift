//
//  WeeklySchedule+Extensions.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-04.
//

import Foundation

extension WeeklySchedule {
    
    var goalsList: [Goal] {
        goals?.array as? [Goal] ?? []
    }
    
    var dailyGoals: [Goal] {
        goalsList.filter { $0.category == .daily }
    }
    
    var weeklyGoals: [Goal] {
        goalsList.filter { $0.category == .weekly }
    }
    
    var dailySchedulesList: [DailySchedule] {
        dailySchedules?.array as? [DailySchedule] ?? []
    }
    
    var category: WeeklyScheduleCategory? {
        WeeklyScheduleCategory.allCases.first { weekday in
            weekday.rawValue == self.categoryName
        }
    }
    
    var workDays: [Weekday] {
        
        return dailySchedulesList.filter { dailySchedule in
            dailySchedule.taskBlocksList.contains(where: { taskBlock in
                taskBlock.category == .work
            })
        }.compactMap {
            $0.weekday
        }
    }
    
    func addGoals(_ goals: [Goal], category: GoalCategory) {
        
        var goalsToKeep: [Goal] = []
        
        switch category {
        case .daily:
            
            goalsToKeep = goalsList.filter { $0.category == .weekly }
        case .weekly:
            
            goalsToKeep = goalsList.filter { $0.category == .daily }
        case .longTerm:
            
            return
        }
        
        let newGoals = goalsToKeep + goals
        self.goals = NSOrderedSet(array: newGoals)
    }
}


extension WeeklySchedule: Schedulable {
    
    var scheduleName: String {
        name ?? "Weekly schedule"
    }
    
    var scheduleType: ScheduleType {
        
        switch category {
        case .holiday:
            return .holidayWeek
        case .work:
            return .workWeek
        default:
            return .hybridWeek
        }
    }
    
    var weeklySchedule: WeeklySchedule? {
        self
    }
}
