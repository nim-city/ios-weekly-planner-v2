//
//  SelectTaskItemsViewModel.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-21.
//

import Foundation
import CoreData

class SelectTaskItemsViewModel: ObservableObject {
    
    @Published var selectedCategory: TaskItemCategory
    @Published var selectedTaskItems: [TaskItem] = []
    
    var title: String {
        
        switch selectedCategory {
        case .chore:
            return "Select chores"
        case .exercise:
            return "Select workouts"
        case .food:
            return "Select meals"
        case .leisure:
            return "Select leisure activities"
        case .routine:
            return "Select routine tasks"
        case .shopping:
            return "Select items to buy"
        case .study:
            return "Select study tasks"
        case .work:
            return "Select work tasks"
        }
    }
    
    var emptyListText: String {
        
        switch selectedCategory {
        case .chore:
            return "No chores yet"
        case .exercise:
            return "No workouts yet"
        case .food:
            return "No meals yet"
        case .leisure:
            return "No leisure activities yet"
        case .routine:
            return "No routine items yet"
        case .shopping:
            return "No purchases yet"
        case .study:
            return "No study tasks yet"
        case .work:
            return "No work tasks yet"
        }
    }
    
    init(category: TaskItemCategory, selectedTaskItems: [TaskItem]) {
        
        self.selectedCategory = category
        self.selectedTaskItems = selectedTaskItems
    }
    
    // Setup
    
    // Actions
    
    func selectTaskItem(_ taskItem: TaskItem) {
        
        if let index = selectedTaskItems.firstIndex(of: taskItem) {
            selectedTaskItems.remove(at: index)
        } else {
            selectedTaskItems.append(taskItem)
        }
    }
    
    func getFilteredTaskItems(from taskItems: [TaskItem]) -> [TaskItem] {
        taskItems.filter { $0.taskItemCategory == selectedCategory }
    }
}
