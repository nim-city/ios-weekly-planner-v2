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
    
    @FetchRequest(sortDescriptors: [.init(keyPath: \Goal.createdAt, ascending: true)]) private var meals: FetchedResults<Meal>
    
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
            .padding(.vertical, Constants.mainPadding)
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
                static let borderWidth: CGFloat = 1
                static let cornerRadius: CGFloat = 20
            }
            enum Spacing {
                static let mainSpacing: CGFloat = 16
            }
            enum Padding {
                static let main: CGFloat = 20
            }
        }
        
        let category: MealCategory
        let meals: [Meal]
        let editTaskItem: (TaskItem) -> Void
        
        @State var expandedListItemIndex: Int? = nil
        
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
                    .padding(.leading, Constants.Padding.main)
                
                if meals.isEmpty {
                    
                    ZStack {
                        Color.white
                        
                        Text(emptyText)
                            .font(AppFonts.detailLabel)
                            .italic()
                            .padding(.vertical, Constants.Padding.main)
                            .frame(maxWidth: .infinity)
                            .background(AppColours.getColourForTaskItemType(.meal).opacity(0.2))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                    .padding(.horizontal, Constants.Padding.main)
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(meals.indices, id: \.self) { mealIndex in

                            let meal = meals[mealIndex]
                            let isBelowExpandedItem = meal == meals.first || expandedListItemIndex == mealIndex - 1
                            let isAboveExpandedItem = meal == meals.last || expandedListItemIndex == mealIndex + 1
                            let showDivider = meal != meals.last && !isAboveExpandedItem && mealIndex != expandedListItemIndex
                            
                            TaskListItemView(taskItem: meal,
                                             taskItemType: .meal,
                                             schedules: meal.dailySchedulesList,
                                             roundTop: isBelowExpandedItem,
                                             roundBottom: isAboveExpandedItem,
                                             showDivider: showDivider,
                                             isExpanded: Binding(get: { mealIndex == self.expandedListItemIndex },
                                                                 set: {
                                if $0 {
                                    self.expandedListItemIndex = mealIndex
                                } else {
                                    self.expandedListItemIndex = nil
                                }
                            }))
                            .onLongPressGesture {
                                editTaskItem(meal)
                            }
                        }
                        
//                        ForEach(meals) { meal in
//                            
//                            TaskListItemView(taskItem: meal,
//                                             taskItemType: .meal,
//                                             schedules: meal.dailySchedulesList,
//                                             isFirst: meal == meals.first,
//                                             isLast: meal == meals.last)
//                                .onLongPressGesture {
//                                    editTaskItem(meal)
//                                }
//                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                    .bottomRightShadow()
                    .padding(.bottom, Constants.Padding.main)
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
