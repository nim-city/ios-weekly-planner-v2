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
    
    @FetchRequest(sortDescriptors: []) private var goals: FetchedResults<Goal>
    
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
            .padding(Constants.mainPadding)
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
        
        private let category: GoalCategory
        private let goals: [Goal]
        private let editTaskItem: (TaskItem) -> Void
        private let title: String
        
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
                
                if goals.isEmpty {
                    
                    Text("No \(category.displayValue) goals yet")
                        .font(AppFonts.detailLabel)
                        .italic()
                        .padding(.vertical, Constants.Padding.emptyTextVertical)
                        .frame(maxWidth: .infinity)
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(goals) { goal in
                            
                            TaskListItemView(taskItem: goal,
                                             schedules: goal.weeklySchedulesList)
                            .onLongPressGesture {
                                editTaskItem(goal)
                            }
                            
                            if goal != goals.last {
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
