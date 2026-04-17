//
//  AddEditTaskBlockViewModel.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-17.
//

import Foundation
import CoreData

class AddEditTaskBlockViewModel: ObservableObject {
    
    private let dailySchedule: DailySchedule
    let isNew: Bool
    
    @Published var taskBlock: TaskBlock?
    @Published var name: String = ""
    @Published var categoryIndex: Int = 0
    @Published var startHour: Int
    @Published var endHour: Int
    @Published var selectedWeekdays: NSMutableOrderedSet = []
    @Published var taskItems: [TaskItem] = []
    
    var title: String {
        if let name = taskBlock?.name {
            return "\(name)"
        } else {
            return "New task block"
        }
    }
    
    var startHourString: String {
        DateTimeFunctions.getHoursStringForHour(startHour)
    }
    
    var endHourString: String {
        DateTimeFunctions.getHoursStringForHour(endHour)
    }
    
    var categoryNames: [String] {
        TaskItemCategory.allCases.map { $0.displayValue.capitalized }
    }
    
    var selectedCategory: TaskItemCategory {
        TaskItemCategory.allCases[categoryIndex]
    }
    
    var selectedCategoryName: String {
        categoryNames[categoryIndex]
    }
    
    var sortedTaskItems: [String: [TaskItem]] {
        var sortedItems: [String: [TaskItem]] = [:]
        taskItems.forEach { taskItem in
            if let category = taskItem.taskItemCategory {
                if sortedItems[category.rawValue] != nil {
                    sortedItems[category.rawValue]?.append(taskItem)
                } else {
                    sortedItems[category.rawValue] = [taskItem]
                }
            }
        }
        return sortedItems
    }
    
    init(dailySchedule: DailySchedule, startHour: Int) {
        
        self.dailySchedule = dailySchedule
        self.isNew = true
        self.startHour = startHour
        self.endHour = startHour + 1
        
        if let weekday = dailySchedule.weekday {
            self.selectedWeekdays = [weekday]
        }
    }
    
    init(dailySchedule: DailySchedule, taskBlock: TaskBlock) {
        
        self.dailySchedule = dailySchedule
        self.taskBlock = taskBlock
        self.isNew = false
        if let name = taskBlock.name {
            self.name = name
        }
        if let category = taskBlock.category,
           let index = TaskItemCategory.allCases.firstIndex(of: category) {
            self.categoryIndex = index
        }
        self.startHour = Int(taskBlock.startHour)
        self.endHour = Int(taskBlock.endHour)
        self.taskItems = taskBlock.taskItemsList
    }

    
    // MARK: - Actions
    
    
    func increaseStartHour() {
        guard startHour < endHour - 1 else { return }
        startHour += 1
    }
    
    func decreaseStartHour() {
        guard startHour > 0 else { return }
        startHour -= 1
    }
    
    func increaseEndHour() {
        guard endHour < 24 else { return }
        endHour += 1
    }
    
    func decreaseEndHour() {
        guard endHour > startHour + 1 else { return }
        endHour -= 1
    }
    
    func updateTaskItems(newTaskItems: [TaskItem]) {
        taskItems = newTaskItems
    }
    
    func clearTaskItems() {
        updateTaskItems(newTaskItems: [])
    }
    
    @discardableResult
    func pressSaveButton(moc: NSManagedObjectContext) -> Bool {
        
        guard !name.isEmpty else { return false }
        
        if isNew {
            
            createNewTaskBlocks(moc: moc)
        } else if let taskBlock {
            
            updateTaskBlock(taskBlock: taskBlock)
        }
        
        do {
            try moc.save()
            return true
        } catch let error {
            print(error)
            return false
        }
    }
    
    private func createNewTaskBlocks(moc: NSManagedObjectContext) {
        
        guard let weekdays = selectedWeekdays.array as? [Weekday] else { return }
        
        dailySchedule.weeklySchedule?.dailySchedulesList.forEach { dailySchedule in
            if let weekday = dailySchedule.weekday, weekdays.contains(weekday) {
                let taskBlock = TaskBlock(context: moc)
                dailySchedule.addTaskBlock(taskBlock)
                updateTaskBlock(taskBlock: taskBlock)
            }
        }
    }
    
    private func updateTaskBlock(taskBlock: TaskBlock) {
        
        taskBlock.name = name
        taskBlock.categoryName = TaskItemCategory.allCases[categoryIndex].rawValue
        taskBlock.startHour = Int16(startHour)
        taskBlock.endHour = Int16(endHour)
        taskBlock.taskItems = NSOrderedSet(array: taskItems)
    }
    
    @discardableResult
    func deleteTaskBlock(moc: NSManagedObjectContext) -> Bool {
        
        guard let taskBlock else { return false }
        moc.delete(taskBlock)
        
        do {
            try moc.save()
            return true
        } catch let error {
            print(error)
            return false
        }
    }
}
