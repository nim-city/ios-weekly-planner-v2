//
//  SelectGoalsViewModel.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-04-13.
//

import Foundation
import CoreData

class SelectGoalsViewModel: ObservableObject {
    
    let weeklySchedule: WeeklySchedule
    
    @Published var goalCategory: GoalCategory
    @Published var selectedGoals: [Goal]
    
    var title: String {
        "Select \(goalCategory.displayValue) goals"
    }
    
    var emptyListText: String {
        "No \(goalCategory.displayValue) goals yet"
    }
    
    init(weeklySchedule: WeeklySchedule, goalCategory: GoalCategory) {
        
        self.weeklySchedule = weeklySchedule
        self.goalCategory = goalCategory
        
        switch goalCategory {
        case .daily:
            selectedGoals = weeklySchedule.dailyGoals
        case .weekly:
            selectedGoals = weeklySchedule.weeklyGoals
        default:
            selectedGoals = []
        }
    }
    
    func selectGoal(_ goal: Goal) {
        
        if let index = selectedGoals.firstIndex(of: goal) {
            selectedGoals.remove(at: index)
        } else {
            selectedGoals.append(goal)
        }
    }
    
    func saveGoals(moc: NSManagedObjectContext) -> Bool {
        
        switch goalCategory {
        case .daily:
            weeklySchedule.addGoals(selectedGoals, category: .daily)
        case .weekly:
            weeklySchedule.addGoals(selectedGoals, category: .weekly)
        default:
            return false
        }
        
        do {
            try moc.save()
            return true
        } catch let error {
            print(error)
            return false
        }
    }
}
