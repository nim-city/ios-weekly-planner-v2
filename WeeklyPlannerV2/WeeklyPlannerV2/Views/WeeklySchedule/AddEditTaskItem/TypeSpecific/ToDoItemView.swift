//
//  ToDoItemView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-27.
//

import SwiftUI

extension AddEditTaskItemView {
    
    struct ToDoItemView: View {
        
        private enum Constants {
            enum Padding {
                static let checkboxTrailing: CGFloat = 10
                static let recurringVertical: CGFloat = 10
            }
            enum Spacing {
                static let mainVertical: CGFloat = 20
            }
        }
        
        @Binding var selectedCategory: TaskItemCategory
        @Binding var selectedPriority: TaskItemPriority
        @Binding var isRecurring: Bool
        
        let canSelectCategory: Bool
        
        private var categoryTexts: [String] {
            TaskItemCategory.toDoItemCategories.map { $0.displayValue.capitalized }
        }
        
        private var priorityTexts: [String] {
            TaskItemPriority.allCases.map { $0.displayValue.capitalized }
        }
        
        var body: some View {
            VStack(spacing: Constants.Spacing.mainVertical) {
                
                // Category
                // Only show if category can be selected
                if canSelectCategory {
                    HStack {
                        
                        Text("Category")
                            .font(AppFonts.formHeading)
                        
                        Spacer()
                        
                        DropdownMenu(texts: categoryTexts,
                                     selectedIndex: Binding(get: {
                            TaskItemCategory.toDoItemCategories.firstIndex(of: selectedCategory) ?? 0
                        }, set: {
                            selectedCategory = TaskItemCategory.toDoItemCategories[$0]
                        }))
                    }
                }
                
                // Priority
                HStack {
                    
                    Text("Priority")
                        .font(AppFonts.formHeading)
                    
                    Spacer()
                    
                    DropdownMenu(texts: priorityTexts,
                                 selectedIndex: Binding(get: {
                        TaskItemPriority.allCases.firstIndex(of: selectedPriority) ?? 0
                    }, set: {
                        selectedPriority = TaskItemPriority.allCases[$0]
                    }))
                }
                
                // Recurring
                HStack {
                    
                    Text("Recurring")
                        .font(AppFonts.formHeading)
                    
                    Spacer()
                    
                    Checkbox(isSelected: $isRecurring)
                        .padding(.trailing, Constants.Padding.checkboxTrailing)
                }
                .padding(.vertical, Constants.Padding.recurringVertical)
            }
        }
    }
}


// MARK - Previews


#Preview {
    AddEditTaskItemView(viewModel: .init(itemType: .toDoItem))
}
