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
    
    @FetchRequest(sortDescriptors: [.init(keyPath: \ToDoItem.dateCreated, ascending: true),
                                    .init(keyPath: \ToDoItem.priority, ascending: true)]) private var toDoItems: FetchedResults<ToDoItem>
    
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
            .padding(.vertical, Constants.mainPadding)
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
        
        let category: TaskItemCategory
        let toDoItems: [ToDoItem]
        let editTaskItem: (TaskItem) -> Void
        
        @State var expandedListItemIndex: Int? = nil
        
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
                    .padding(.leading, Constants.Padding.main)
                
                if toDoItems.isEmpty {
                    
                    ZStack {
                        Color.white
                        
                        Text(emptyText)
                            .font(AppFonts.detailLabel)
                            .italic()
                            .padding(.vertical, Constants.Padding.main)
                            .frame(maxWidth: .infinity)
                            .background(AppColours.getColourForTaskItemType(.toDoItem).opacity(0.2))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                    .padding(.horizontal, Constants.Padding.main)
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(toDoItems.indices, id: \.self) { toDoItemIndex in

                            let toDoItem = toDoItems[toDoItemIndex]
                            let isBelowExpandedItem = toDoItem == toDoItems.first || expandedListItemIndex == toDoItemIndex - 1
                            let isAboveExpandedItem = toDoItem == toDoItems.last || expandedListItemIndex == toDoItemIndex + 1
                            let showDivider = toDoItem != toDoItems.last && !isAboveExpandedItem && toDoItemIndex != expandedListItemIndex
                            
                            TaskListItemView(taskItem: toDoItem,
                                             taskItemType: .toDoItem,
                                             schedules: toDoItem.dailySchedulesList,
                                             roundTop: isBelowExpandedItem,
                                             roundBottom: isAboveExpandedItem,
                                             showDivider: showDivider,
                                             isExpanded: Binding(get: { toDoItemIndex == self.expandedListItemIndex },
                                                                 set: {
                                if $0 {
                                    self.expandedListItemIndex = toDoItemIndex
                                } else {
                                    self.expandedListItemIndex = nil
                                }
                            }))
                            .onLongPressGesture {
                                editTaskItem(toDoItem)
                            }
                        }
                        
//                        ForEach(toDoItems) { toDoItem in
//                            
//                            TaskListItemView(taskItem: toDoItem,
//                                             taskItemType: .toDoItem,
//                                             schedules: toDoItem.dailySchedulesList,
//                                             isFirst: toDoItem == toDoItems.first,
//                                             isLast: toDoItem == toDoItems.last)
//                                .onLongPressGesture {
//                                    editTaskItem(toDoItem)
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
        ToDoItemsListView(editTaskItem: { _ in })
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.gray)
}
