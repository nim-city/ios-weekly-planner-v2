//
//  WeeklySummaryViewModel.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-05.
//

import Foundation

class WeeklySummaryViewModel: ObservableObject {
    
    @Published var weeklySchedule: WeeklySchedule
    
    let dateText: String = {
        guard let startDate = DateTimeFunctions.weekStartDate, let endDate = DateTimeFunctions.weekEndDate else { return "" }
        let startDateString = DateTimeFunctions.getShortDateString(fromDate: startDate)
        let endDateString = DateTimeFunctions.getShortDateString(fromDate: endDate)
        return "\(startDateString)  -  \(endDateString)"
    }()
    
    var title: String {
        weeklySchedule.name ?? "Weekly schedule"
    }
    
    var workdaysText: String? {
        
        let workDays = weeklySchedule.dailySchedulesList.filter { dailySchedule in
            dailySchedule.taskBlocksList.contains(where: { taskBlock in
                taskBlock.category == .work
            })
        }.compactMap {
            $0.weekday
        }
        
        let workdayNames = workDays.map { $0.shortName }
        return workDays.isEmpty ? nil : workdayNames.joined(separator: ",  ")
    }
    
    init(weeklySchedule: WeeklySchedule) {
        self.weeklySchedule = weeklySchedule
    }
}
