//
//  EditDailyScheduleViewModel.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-15.
//

import Foundation
import CoreData

class EditDailyScheduleViewModel: ObservableObject, Identifiable {
    
    @Published var weeklySchedule: WeeklySchedule
    @Published var selectedScheduleIndex: Int = 0
    
    @Published var selectedHour: Int?
    @Published var isPresentingAddEditTaskBlockView: Bool = false
    
    var title: String {
        guard let weekday = dailySchedule.weekday else { return "Edit daily schedule" }
        return "Edit \(weekday.displayName)"
    }
    
    var dailySchedule: DailySchedule {
        weeklySchedule.dailySchedulesList[selectedScheduleIndex]
    }
    
    var taskBlocks: [TaskBlock] {
        dailySchedule.taskBlocksList
    }
    
    init(weeklySchedule: WeeklySchedule, initialWeekdayIndex: Int) {

        self.weeklySchedule = weeklySchedule
        self.selectedScheduleIndex = initialWeekdayIndex
    }
    
    func tapOnHourBlock(forHour hour: Int) {
        selectedHour = hour
        isPresentingAddEditTaskBlockView = true
    }
    
    func getSelectedTaskBlock() -> TaskBlock? {
        
        guard let hour = selectedHour else { return nil }
        return taskBlocks.first { $0.containsHour(hour) }
    }
    
    func getIsWeekdaySelected(_ weekday: Weekday) -> Bool {
        weekday == Weekday.allCases[selectedScheduleIndex]
    }
    
    func selectWeekday(_ weekday: Weekday) {
        guard let index = Weekday.allCases.firstIndex(of: weekday) else { return }
        selectedScheduleIndex = index
    }
    
    func save(moc: NSManagedObjectContext) -> Bool {

        do {
            try moc.save()
            return true
        } catch let error {
            print("Failed to save daily schedule: \(error)")
            return false
        }
    }
    
    func revertMock(moc: NSManagedObjectContext) {
        if moc.hasChanges {
            moc.rollback()
        }
    }
}
