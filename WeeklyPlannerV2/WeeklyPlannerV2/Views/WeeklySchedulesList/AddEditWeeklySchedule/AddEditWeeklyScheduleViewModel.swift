//
//  AddEditWeeklyScheduleViewModel.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-09.
//

import Foundation
import CoreData

class AddEditWeeklyScheduleViewModel: ObservableObject {
    
    let maxNameLength: Int = 30
    
    let isNewSchedule: Bool
    @Published private var weeklySchedule: WeeklySchedule?
    @Published var nameText: String = ""
    @Published var selectedCategoryIndex: Int = 0
    var selectedColourData: Data?
    
    var title: String {
        if let name = weeklySchedule?.name {
            "Edit \(name)"
        } else {
            "Add a schedule"
        }
    }
    
    var categoryTexts: [String] {
        WeeklyScheduleCategory.allCases.map { $0.displayName.capitalized }
    }
    
    var selectedCategory: WeeklyScheduleCategory {
        WeeklyScheduleCategory.allCases[selectedCategoryIndex]
    }
    
    // For now, just validate that name text is not empty
    var areInputsValid: Bool {
        
        // Text must be betwee 1 and 30 characters inclusive
        nameText.count > 0 && nameText.count <= maxNameLength
    }
    
    init(weeklySchedule: WeeklySchedule? = nil) {
        
        self.isNewSchedule = weeklySchedule == nil
        
        // Replace default values if weekly schedule is not nil
        if let weeklySchedule {
            self.weeklySchedule = weeklySchedule
            self.nameText = weeklySchedule.name ?? ""
            if let category = weeklySchedule.category,
               let index = WeeklyScheduleCategory.allCases.firstIndex(of: category) {
                self.selectedCategoryIndex = index
            }
            selectedColourData = weeklySchedule.colourData
        }
    }
    
    // Update selected schedule or create a new schedule with the given name and selected category
    func pressSaveButton(moc: NSManagedObjectContext) -> Bool {
        
        guard areInputsValid else {
            return false
        }
        
        return saveSchedule(moc: moc)
    }
    
    private func saveSchedule(moc: NSManagedObjectContext) -> Bool {
        
        if weeklySchedule == nil {
            self.weeklySchedule = addWeeklySchedule(moc: moc)
        }
        weeklySchedule?.name = nameText
        weeklySchedule?.categoryName = selectedCategory.rawValue
        weeklySchedule?.colourData = selectedColourData ?? AppColours.appTheme.encodeToData()
        
        do {
            try moc.save()
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    private func addWeeklySchedule(moc: NSManagedObjectContext) -> WeeklySchedule {
        
        let weeklySchedule = WeeklySchedule(context: moc)
        weeklySchedule.id = UUID()
        weeklySchedule.goals = .init()
        weeklySchedule.dailySchedules = .init()
        addDailySchedules(toWeeklySchedule: weeklySchedule, moc: moc)
        
        return weeklySchedule
    }
    
    private func addDailySchedules(toWeeklySchedule weeklySchedule: WeeklySchedule, moc: NSManagedObjectContext) {
        
        Weekday.allCases.forEach { weekday in
            let dailySchedule = DailySchedule(context: moc)
            dailySchedule.weekdayIndex = Int16(weekday.rawValue)
            dailySchedule.taskBlocks = .init()
            weeklySchedule.addToDailySchedules(dailySchedule)
        }
    }
    
    func pressDeleteButton(moc: NSManagedObjectContext) -> Bool {
        
        guard let weeklySchedule else { return false }
        
        weeklySchedule.dailySchedulesList.forEach { dailySchedule in
            
            // Delete task blocks
            dailySchedule.taskBlocksList.forEach { taskBlock in
                moc.delete(taskBlock)
            }
            
            // Delete daily schedule
            moc.delete(dailySchedule)
        }
        
        // Delete weekly schedule
        moc.delete(weeklySchedule)
        
        do {
            try moc.save()
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
}
