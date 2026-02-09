//
//  DailySchedule+Extensions.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-09.
//

import Foundation

extension DailySchedule {
    
    var weekday: Weekday? {
        Weekday.allCases.first { weekday in
            self.weekdayIndex == weekday.rawValue
        }
    }
    
    var taskBlocksList: [TaskBlock] {
        taskBlocks?.array as? [TaskBlock] ?? []
    }
    
    func containsTaskBlock(_ taskBlock: TaskBlock) -> Bool {
        
        guard let blocks = taskBlocks else { return false }
        return blocks.contains(taskBlock)
    }
    
    func addTaskBlock(_ taskBlock: TaskBlock) {
        
        if var blocks = taskBlocks?.array as? [TaskBlock] {
            
            // Find the first index where startHour is greater than taskBlock.endHour
            if let index = blocks.firstIndex(where: {
                $0.startHour > taskBlock.endHour
            }) {
                
                blocks.insert(taskBlock, at: index)
            } else {
                
                blocks.append(taskBlock)
            }
            
            taskBlocks = NSOrderedSet(array: blocks)
        } else {
            
            taskBlocks = NSOrderedSet(array: [taskBlock])
        }
    }
}


extension DailySchedule: Schedulable {
    
    var scheduleName: String {
        weekday?.shortName ?? "N/A"
    }
    
    var scheduleType: ScheduleType {
        // FIXME: Update to detect whether it's actually a work day based on your schedule
        // For now, just return Mon-Fri = work and Sa-Su = off
        switch weekday {
        case .monday, .tuesday, .wednesday, .thursday, .friday:
            return .workDay
        default:
            return .restDay
        }
    }
}
