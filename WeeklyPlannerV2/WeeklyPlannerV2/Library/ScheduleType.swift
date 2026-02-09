//
//  ScheduleType.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-17.
//

protocol Schedulable: Hashable {
    
    var scheduleName: String { get }
    var scheduleType: ScheduleType { get }
    var weeklySchedule: WeeklySchedule? { get }
}

enum ScheduleType {
    
    case workDay
    case restDay
    case workWeek
    case holidayWeek
    case hybridWeek
}
