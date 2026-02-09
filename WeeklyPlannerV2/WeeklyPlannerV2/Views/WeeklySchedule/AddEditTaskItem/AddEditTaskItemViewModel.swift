//
//  AddEditTaskItemViewModel.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-10.
//

import Foundation
import CoreData

class AddEditTaskItemViewModel: ObservableObject {
    
    @Published var itemToEdit: TaskItem?
    @Published var selectedItemType: TaskItemType
    @Published var itemName: String = ""
    @Published var completed: Bool = false
    @Published var notes: String = ""
    
    // Specific to particular item types
    @Published var selectedGoalCategory: GoalCategory = .daily
    @Published var selectedMealCategory: MealCategory = .breakfast
    @Published var selectedPriority: TaskItemPriority = .low
    @Published var recurring: Bool = false
    @Published var selectedToDoItemCategory: TaskItemCategory = .chore
    @Published var exercises: [String] = [""]
    
    var isNew: Bool {
        itemToEdit == nil
    }
    
    var title: String {
        let prefix = isNew ? "Add" : "Edit"
        return "\(prefix) \(selectedItemType.displayValue.capitalized)"
    }
    
    var namePlaceholder: String {
        
        let name = selectedItemType.displayValue
        
        guard !name.isEmpty else { return "" }
        let displayName = name.prefix(1).capitalized + name.dropFirst()
        
        return "\(displayName) name"
    }
    
    init(itemType: TaskItemType) {
        self.selectedItemType = itemType
    }
    
    init(taskItemCategory: TaskItemCategory) {
        self.selectedToDoItemCategory = taskItemCategory
        self.selectedItemType = taskItemCategory.taskItemType
    }
    
    convenience init(itemToEdit: TaskItem) {
        
        if let goal = itemToEdit as? Goal {
            
            self.init(itemType: .goal)
            self.selectedGoalCategory = GoalCategory.createFromRawValue(string: goal.categoryName) ?? .daily
            self.itemToEdit = goal
        } else if let meal = itemToEdit as? Meal {
            
            self.init(itemType: .meal)
            self.selectedMealCategory = MealCategory.createFromRawValue(string: meal.categoryName) ?? .breakfast
            self.itemToEdit = meal
        } else if let toBuyItem = itemToEdit as? ToBuyItem {
            
            self.init(itemType: .toBuyItem)
            self.selectedPriority = TaskItemPriority.createFromRawValue(int: toBuyItem.priority) ?? .low
            self.itemToEdit = toBuyItem
        } else if let toDoItem = itemToEdit as? ToDoItem {
            
            self.init(itemType: .toDoItem)
            self.selectedPriority = TaskItemPriority.createFromRawValue(int: toDoItem.priority) ?? .low
            self.selectedToDoItemCategory = TaskItemCategory.createToDoItemFromRawValue(string: toDoItem.categoryName) ?? .chore
            self.recurring = toDoItem.recurring
            self.itemToEdit = toDoItem
        } else if let workout = itemToEdit as? Workout {
            
            self.init(itemType: .workout)
            self.exercises = workout.exercises ?? [""]
            self.itemToEdit = workout
        } else {
            
            // FIXME: Come up with a better solution. For now, just default to goal
            self.init(itemType: .goal)
            self.selectedGoalCategory = .daily
        }
        
        self.itemName = itemToEdit.name ?? ""
        self.completed = itemToEdit.completed
        self.notes = itemToEdit.notes ?? ""
    }
    
    func pressSaveButton(moc: NSManagedObjectContext) -> Bool {
        
        var taskItem: TaskItem?
        
        switch selectedItemType {
        case .goal:
            
            let goal = itemToEdit as? Goal ?? Goal(context: moc)
            goal.categoryName = selectedGoalCategory.rawValue
            taskItem = goal
        case .meal:
            
            let meal = itemToEdit as? Meal ?? Meal(context: moc)
            meal.categoryName = selectedMealCategory.rawValue
            taskItem = meal
        case .toBuyItem:
            
            let toBuyItem = itemToEdit as? ToBuyItem ?? ToBuyItem(context: moc)
            toBuyItem.priority = selectedPriority.rawValue
            taskItem = toBuyItem
        case .toDoItem:
            
            let toDoItem = itemToEdit as? ToDoItem ?? ToDoItem(context: moc)
            toDoItem.categoryName = selectedToDoItemCategory.rawValue
            toDoItem.priority = selectedPriority.rawValue
            toDoItem.recurring = recurring
            taskItem = toDoItem
        case .workout:
            
            let workout = itemToEdit as? Workout ?? Workout(context: moc)
            workout.exercises = exercises
            taskItem = workout
        }
        
        taskItem?.name = itemName
        taskItem?.completed = completed
        taskItem?.notes = notes
        
        do {
            
            try moc.save()
            return true
        } catch let error {
            
            print(error)
            return false
        }
    }
    
    func pressDeleteButton(moc: NSManagedObjectContext) -> Bool {
        
        guard let itemToEdit else { return false }
        
        moc.delete(itemToEdit)
        
        do {
            
            try moc.save()
            return true
        } catch let error {
            
            print(error)
            return false
        }
    }
}
