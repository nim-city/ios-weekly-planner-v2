//
//  GoalsListView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-12.
//

import SwiftUI

struct GoalsListView: View {
    
    private enum Constants {
        static let bottomPadding: CGFloat = 40
        static let mainSpacing: CGFloat = 20
        static let mainPadding: CGFloat = 20
    }
    
    @FetchRequest(sortDescriptors: [.init(keyPath: \Goal.createdAt, ascending: true)]) private var goals: FetchedResults<Goal>
    
    let editTaskItem: (TaskItem) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.mainSpacing) {
                
                // Goals lists: daily, weekly, then monthly
                ForEach(GoalCategory.allCases, id: \.self) { category in
                    
                    let filteredGoals = goals.filter { $0.categoryName == category.rawValue }
                    
                    GoalsList(category: category,
                              goals: filteredGoals,
                              editTaskItem: editTaskItem)
                }
            }
            .padding(.vertical, Constants.mainPadding)
            .padding(.bottom, Constants.bottomPadding)
        }
        .scrollIndicators(.hidden)
        .tint(.goalDarkened)
    }
}


// MARK: Subviews


extension GoalsListView {
    
    // List of goals for a specific category
    private struct GoalsList: View {
        
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
        
        private let category: GoalCategory
        private let goals: [Goal]
        private let editTaskItem: (TaskItem) -> Void
        private let title: String
        
        @State var expandedListItemIndex: Int? = nil
        
        init(category: GoalCategory, goals: [Goal], editTaskItem: @escaping (TaskItem) -> Void) {
            
            self.category = category
            self.goals = goals
            self.editTaskItem = editTaskItem
            
            // Set title
            switch category {
            case .daily:
                self.title = "Daily goals"
            case .weekly:
                self.title = "Weekly goals"
            case .longTerm:
                self.title = "Long term goals"
            }
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.mainSpacing) {
                
                Text(title)
                    .font(AppFonts.subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, Constants.Padding.main)
                
                if goals.isEmpty {
                    
                    ZStack {
                        Color.white
                        
                        Text("No \(category.displayValue) goals yet")
                            .font(AppFonts.detailLabel)
                            .italic()
                            .padding(.vertical, Constants.Padding.main)
                            .frame(maxWidth: .infinity)
                            .background(AppColours.getColourForTaskItemType(.goal).opacity(0.2))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                    .padding(.horizontal, Constants.Padding.main)
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(goals.indices, id: \.self) { goalIndex in

                            let goal = goals[goalIndex]
                            let isBelowExpandedItem = goal == goals.first || expandedListItemIndex == goalIndex - 1
                            let isAboveExpandedItem = goal == goals.last || expandedListItemIndex == goalIndex + 1
                            let showDivider = goal != goals.last && !isAboveExpandedItem && goalIndex != expandedListItemIndex
                            
                            TaskListItemView(taskItem: goal,
                                             taskItemType: .goal,
                                             schedules: goal.weeklySchedulesList,
                                             roundTop: isBelowExpandedItem,
                                             roundBottom: isAboveExpandedItem,
                                             showDivider: showDivider,
                                             isExpanded: Binding(get: { goalIndex == self.expandedListItemIndex },
                                                                 set: {
                                if $0 {
                                    self.expandedListItemIndex = goalIndex
                                } else {
                                    self.expandedListItemIndex = nil
                                }
                            }))
                            .onLongPressGesture {
                                editTaskItem(goal)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                    .bottomRightShadow()
                    .padding(.bottom, Constants.Padding.main)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


// MARK: - Previews


#Preview {
    VStack {
        GoalsListView(editTaskItem: { _ in })
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.gray)
}
