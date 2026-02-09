//
//  MealView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-27.
//

import SwiftUI

extension AddEditTaskItemView {
    
    struct MealView: View {
        
        @Binding var selectedCategory: MealCategory
        
        private var texts: [String] {
            MealCategory.allCases.map { $0.displayValue.capitalized }
        }
        
        var body: some View {
            HStack {
                
                Text("Meal Category")
                    .font(AppFonts.formHeading)
                
                Spacer()
                
                DropdownMenu(texts: texts, selectedIndex: Binding(get: {
                    MealCategory.allCases.firstIndex(of: selectedCategory) ?? 0
                }, set: { newIndex in
                    selectedCategory = MealCategory.allCases[newIndex]
                }))
            }
        }
    }
}
