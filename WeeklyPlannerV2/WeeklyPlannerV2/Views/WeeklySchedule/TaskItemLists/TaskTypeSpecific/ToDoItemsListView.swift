//
//  ToDoItemsListView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-12.
//

import SwiftUI

struct ToDoItemsListView: View {
    
    private enum Constants {
        static let bottomPadding: CGFloat = 40
        static let mainSpacing: CGFloat = 20
        static let mainPadding: CGFloat = 20
    }
    
    @FetchRequest(sortDescriptors: []) private var toDoItems: FetchedResults<ToDoItem>
    
    let editTaskItem: (TaskItem) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.mainSpacing) {
                
                // To buy item lists; high priority then low prioritys
                ForEach(TaskItemCategory.toDoItemCategories, id: \.self) { category in
                    
                    let filteredToDoItems = toDoItems.filter { $0.categoryName == category.rawValue }
                    // TODO: Sort by priority
                    ToDoItemsList(category: category, toDoItems: filteredToDoItems, editTaskItem: editTaskItem)
                }
            }
            .padding(Constants.mainPadding)
            .padding(.bottom, Constants.bottomPadding)
        }
        .scrollIndicators(.hidden)
        .tint(.toDoItemDarkened)
    }
}


// MARK: Subviews


extension ToDoItemsListView {
    
    // List of toDoItems for a specific category
    private struct ToDoItemsList: View {
        
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
        
        let category: TaskItemCategory
        let toDoItems: [ToDoItem]
        let editTaskItem: (TaskItem) -> Void
        
        var title: String {
            switch category {
            case .chore:
                "Chores"
            case .leisure:
                "Leisure activities"
            case .routine:
                "Routine tasks"
            case .study:
                "Study tasks"
            case .work:
                "Work tasks"
            default:
                ""
            }
        }
        
        var emptyText: String {
            switch category {
            case .chore:
                "No chores yet"
            case .leisure:
                "No leisure activities yet"
            case .routine:
                "No routine tasks yet"
            case .study:
                "No study tasks yet"
            case .work:
                "No work tasks yet"
            default:
                ""
            }
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.mainSpacing) {
                
                Text(title)
                    .font(AppFonts.subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if toDoItems.isEmpty {
                    
                    Text(emptyText)
                        .font(AppFonts.detailLabel)
                        .italic()
                        .padding(.vertical, Constants.Padding.emptyTextVertical)
                        .frame(maxWidth: .infinity)
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(toDoItems) { toDoItem in
                            
                            TaskListItemView(taskItem: toDoItem,
                                             schedules: toDoItem.dailySchedulesList)
                                .onLongPressGesture {
                                    editTaskItem(toDoItem)
                                }
                            
                            if toDoItem != toDoItems.last {
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
        ToDoItemsListView(editTaskItem: { _ in })
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.gray)
}
