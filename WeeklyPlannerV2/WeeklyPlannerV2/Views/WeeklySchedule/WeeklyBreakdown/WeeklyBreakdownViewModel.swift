//
//  WeeklyBreakdownViewModel.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-04.
//

import Foundation

class WeeklyBreakdownViewModel: ObservableObject {
    
    let weeklySchedule: WeeklySchedule
    @Published var dailySchedules: [DailySchedule]
    @Published var selectedWeekdayIndex: Int
    
    var currentDailySchedule: DailySchedule? {
        guard dailySchedules.count > selectedWeekdayIndex else { return nil }
        return dailySchedules[selectedWeekdayIndex]
    }
    
    var title: String {
        Weekday.createFromRawValue(selectedWeekdayIndex)?.displayName ?? "Weekly Breakdown"
    }
    
    init(weeklySchedule: WeeklySchedule) {
        
        self.weeklySchedule = weeklySchedule
        self.dailySchedules = weeklySchedule.dailySchedulesList
        self.selectedWeekdayIndex = DateTimeFunctions.currentWeekdayIndex
    }
    
    func selectWeekday(atIndex weekdayIndex: Int) {
        
        if weekdayIndex != selectedWeekdayIndex {
            selectedWeekdayIndex = weekdayIndex
        }
    }
}
