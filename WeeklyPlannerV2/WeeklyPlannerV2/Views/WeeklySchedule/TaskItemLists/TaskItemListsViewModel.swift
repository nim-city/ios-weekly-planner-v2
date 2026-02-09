//
//  TaskItemListsViewModel.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-09.
//

import Foundation

class TaskItemListsViewModel: ObservableObject {
    
    let weeklySchedule: WeeklySchedule
    @Published var selectedTaskItemType: TaskItemType = .goal
    var taskItemToEdit: TaskItem?
    
    var title: String {
        selectedTaskItemType.displayValue.capitalized + "s"
    }
    
    var emptyListText: String {
        switch selectedTaskItemType {
        case .goal:
            return "No goals added yet"
        case .meal:
            return "No meals added yet"
        case .toBuyItem:
            return "No items to buy added yet"
        case .toDoItem:
            return "No to do items added yet"
        case .workout:
            return "No workouts added yet"
        }
    }
    
    init(weeklySchedule: WeeklySchedule) {
        self.weeklySchedule = weeklySchedule
    }
    
    func getTaskItemTypeLabel(forType taskItemType: TaskItemType) -> String {
        
        switch taskItemType {
        case .goal, .meal, .workout:
            return taskItemType.shortDisplayValue + "s"
        case .toBuyItem, .toDoItem:
            return taskItemType.shortDisplayValue
        }
    }
}
