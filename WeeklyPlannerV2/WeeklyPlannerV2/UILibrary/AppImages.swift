//
//  AppImages.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-02-15.
//

class AppImages {
    
    private init() {}
    
    static func getSystemImageNameForTaskItemCategory(_ category: TaskItemCategory) -> String {
        
        switch category {
        case .chore:
            return "washer"
        case .exercise:
            return "dumbbell.fill"
        case .food:
            return "fork.knife"
        case .leisure:
            return "moon.zzz.fill"
        case .routine:
            return "person.badge.clock.fill"
        case .shopping:
            return "cart.fill"
        case .study:
            return "book.fill"
        case .work:
            return "desktopcomputer"
        }
    }
}
