//
//  AddEditTaskBlockViewModel.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-17.
//

import Foundation
import CoreData

class AddEditTaskBlockViewModel: ObservableObject {
    
    enum ValidationError {
        case invalidName
        case invalidTimeSlot
        case timeSlotOverlap
        
        var message: String {
            switch self {
            case .invalidName:
                return "Name must be between 1 and 30 characters"
            case .invalidTimeSlot:
                return "End time must be later than start time"
            case .timeSlotOverlap:
                return "Time slot must not overlap with another task block"
            }
        }
    }
    
    private let dailySchedule: DailySchedule
    let isNew: Bool
    // TODO: Make this a universal constant so we can use this anywhere
    let maxNameLength: Int = 30
    
    @Published var taskBlock: TaskBlock?
    @Published var name: String = ""
    @Published var categoryIndex: Int = 0
    @Published var startHour: Int
    @Published var startMinutes: Int
    @Published var endHour: Int
    @Published var endMinutes: Int
    @Published var selectedWeekdays: NSMutableOrderedSet = []
    @Published var taskItems: [TaskItem] = []
    @Published var validationError: ValidationError? = nil
    
    var title: String {
        if let name = taskBlock?.name {
            return "\(name)"
        } else {
            return "New task block"
        }
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
    
    var isSaveButtonEnabled: Bool {
        validateName()
    }
    
    init(dailySchedule: DailySchedule, startHour: Int) {
        
        self.dailySchedule = dailySchedule
        self.isNew = true
        self.startHour = startHour
        self.startMinutes = 0
        self.endHour = startHour + 1
        self.endMinutes = 0
        
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
        self.startMinutes = Int(taskBlock.startMinutes)
        self.endHour = Int(taskBlock.endHour)
        self.endMinutes = Int(taskBlock.endMinutes)
        self.taskItems = taskBlock.taskItemsList
    }

    
    // MARK: - Actions
    
    
    func updateTaskItems(newTaskItems: [TaskItem]) {
        taskItems = newTaskItems
    }
    
    func clearTaskItems() {
        updateTaskItems(newTaskItems: [])
    }
    
    @discardableResult
    func pressSaveButton(moc: NSManagedObjectContext) -> Bool {
        
        guard validateInputs() else { return false }
        
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
    
    private func validateInputs() -> Bool {
        
        if !validateName() {
            validationError = .invalidName
            return false
        }
        
        if !validateTimes() {
            validationError = .invalidTimeSlot
            return false
        }
        
        if !validateNoBlockOverlap() {
            validationError = .timeSlotOverlap
            return false
        }
        
        return true
    }
    
    private func validateName() -> Bool {
        !name.isEmpty
    }
    
    private func validateTimes() -> Bool {
        if startHour > endHour {
            return false
        } else if startHour == endHour && startMinutes >= endMinutes {
            return false
        }
        return true
    }
    
    private func validateNoBlockOverlap() -> Bool {
        
        let startTime = DateTimeFunctions.combineHourAndMinutes(hour: startHour, minutes: startMinutes)
        let endTime = DateTimeFunctions.combineHourAndMinutes(hour: endHour, minutes: endMinutes)
        
        // Ensure there is no overlap with other task blocks
        for block in dailySchedule.taskBlocksList {
            
            if block == self.taskBlock { continue }
            
            let blockStartTime = DateTimeFunctions.combineHourAndMinutes(hour: Int(block.startHour), minutes: Int(block.startMinutes))
            let blockEndTime = DateTimeFunctions.combineHourAndMinutes(hour: Int(block.endHour), minutes: Int(block.endMinutes))
            
            if startTime <= blockStartTime && endTime <= blockStartTime {
                continue
            } else if startTime >= blockEndTime && endTime >= blockEndTime {
                continue
            } else {
                return false
            }
        }
        
        return true
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
        taskBlock.startMinutes = Int16(startMinutes)
        taskBlock.endHour = Int16(endHour)
        taskBlock.endMinutes = Int16(endMinutes)
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
