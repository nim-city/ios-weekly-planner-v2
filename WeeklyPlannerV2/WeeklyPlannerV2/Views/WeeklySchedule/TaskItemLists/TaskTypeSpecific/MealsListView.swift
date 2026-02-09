//
//  MealsListView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-12.
//

import SwiftUI

struct MealsListView: View {
    
    private enum Constants {
        static let bottomPadding: CGFloat = 40
        static let mainSpacing: CGFloat = 20
        static let mainPadding: CGFloat = 20
    }
    
    @FetchRequest(sortDescriptors: []) private var meals: FetchedResults<Meal>
    
    let editTaskItem: (TaskItem) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.mainSpacing) {
                
                // Meals lists: breakfasts, lunches, dinners, then snacks
                ForEach(MealCategory.allCases, id: \.self) { category in
                    
                    let filteredMeals = meals.filter { $0.categoryName == category.rawValue }
                    MealsList(category: category, meals: filteredMeals, editTaskItem: editTaskItem)
                }
            }
            .padding(Constants.mainPadding)
            .padding(.bottom, Constants.bottomPadding)
        }
        .scrollIndicators(.hidden)
        .tint(.mealDarkened)
    }
}


// MARK: Subviews


extension MealsListView {
    
    // List of meals for a specific category
    private struct MealsList: View {
        
        enum Constants {
            enum Sizing {
                static let borderWidth: CGFloat = 2
                static let cornerRadius: CGFloat = 20
            }
            enum Spacing {
                static let mainSpacing: CGFloat = 16
            }
            enum Padding {
                static let dividerHorizontal: CGFloat = 14
                static let emptyTextVertical: CGFloat = 20
                static let nonEmptyListBottom: CGFloat = 20
            }
        }
        
        let category: MealCategory
        let meals: [Meal]
        let editTaskItem: (TaskItem) -> Void
        
        var title: String {
            category.pluralDisplayValue.capitalized
        }
        
        var emptyText: String {
            "No \(category.pluralDisplayValue) yet"
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.mainSpacing) {
                
                Text(title)
                    .font(AppFonts.subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if meals.isEmpty {
                    
                    Text(emptyText)
                        .font(AppFonts.detailLabel)
                        .italic()
                        .padding(.vertical, Constants.Padding.emptyTextVertical)
                        .frame(maxWidth: .infinity)
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(meals) { meal in
                            
                            TaskListItemView(taskItem: meal,
                                             schedules: meal.dailySchedulesList)
                                .onLongPressGesture {
                                    editTaskItem(meal)
                                }
                            
                            if meal != meals.last {
                                Divider()
                                    .background(AppColours.dividerBold)
                                    .padding(.horizontal, Constants.Padding.dividerHorizontal)
                            }
                        }
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                            .strokeBorder(.black, lineWidth: Constants.Sizing.borderWidth)
                    }
                    .padding(.bottom, Constants.Padding.nonEmptyListBottom)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}


// MARK: - Previews


#Preview {
    VStack {
        MealsListView(editTaskItem: { _ in })
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.gray)
}
