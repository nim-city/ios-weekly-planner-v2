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
                .padding(.leading, category == taskItemCategories.first ? 5 : 0)
                .padding(.trailing, category == taskItemCategories.last ? 5 : 0)
                .background(isSelected ? AppColours.getColourForTaskItemCategory(category) : .white)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.black, lineWidth: 2)
        }
    }
}


// MARK: - Subviews


extension TaskItemCategorySelector {
    
    private struct TaskItemCategoryButton: View {
        
        private enum Constants {
            enum Sizing {
                static let height: CGFloat = 40
                static let width: CGFloat = 44
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
