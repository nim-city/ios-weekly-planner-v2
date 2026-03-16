//
//  TaskItemCategorySelector.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-02-15.
//

import SwiftUI

struct TaskItemCategorySelector: View {
    
    let taskItemCategories: [TaskItemCategory]
    @Binding var selectedCategory: TaskItemCategory
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(taskItemCategories) { category in
                
                let isSelected = category == selectedCategory
                TaskItemCategoryButton(taskItemCategory: category,
                                       onSelect: { selectedCategory = $0 })
                .tint(isSelected ? .white : .black)
                .background(isSelected ? AppColours.getColourForTaskItemCategory(category) : .white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical, 5)
                .padding(.horizontal, 2)
                .padding(.leading, category == taskItemCategories.first ? 4 : 0)
                .padding(.trailing, category == taskItemCategories.last ? 4 : 0)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .bottomRightShadow()
    }
}


// MARK: - Subviews


extension TaskItemCategorySelector {
    
    private struct TaskItemCategoryButton: View {
        
        private enum Constants {
            enum Sizing {
                static let height: CGFloat = 40
                static let width: CGFloat = 40
            }
        }
        
        let taskItemCategory: TaskItemCategory
        let onSelect: (TaskItemCategory) -> Void
        
        var imageName: String {
            AppImages.getSystemImageNameForTaskItemCategory(taskItemCategory)
        }
        
        var body: some View {
            Image(systemName: imageName)
                .font(AppFonts.iconMedium)
                .frame(width: Constants.Sizing.width, height: Constants.Sizing.height)
                .foregroundStyle(.tint)
                .onTapGesture {
                    onSelect(taskItemCategory)
                }
        }
    }
}
