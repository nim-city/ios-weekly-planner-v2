//
//  ToBuyItemsListView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-12.
//

import SwiftUI

struct ToBuyItemsListView: View {
    
    private enum Constants {
        static let bottomPadding: CGFloat = 40
        static let mainSpacing: CGFloat = 20
        static let mainPadding: CGFloat = 20
    }
    
    @FetchRequest(sortDescriptors: []) private var toBuyItems: FetchedResults<ToBuyItem>
    
    let editTaskItem: (TaskItem) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.mainSpacing) {
                
                // To buy item lists; high priority then low prioritys
                ForEach(TaskItemPriority.allCases, id: \.self) { priority in
                    
                    let filteredToBuyItems = toBuyItems.filter { $0.priority == priority.rawValue }
                    ToBuyItemsList(priority: priority, toBuyItems: filteredToBuyItems, editTaskItem: editTaskItem)
                }
            }
            .padding(Constants.mainPadding)
            .padding(.bottom, Constants.bottomPadding)
        }
        .scrollIndicators(.hidden)
        .tint(.toBuyItemDarkened)
    }
}


// MARK: Subviews


extension ToBuyItemsListView {
    
    // List of toBuyItems for a specific category
    private struct ToBuyItemsList: View {
        
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
        
        let priority: TaskItemPriority
        let toBuyItems: [ToBuyItem]
        let editTaskItem: (TaskItem) -> Void
        
        var title: String {
            "\(priority.displayValue.capitalized) priority"
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.mainSpacing) {
                
                Text(title)
                    .font(AppFonts.subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if toBuyItems.isEmpty {
                    
                    Text("No \(priority.displayValue) priority items yet")
                        .font(AppFonts.detailLabel)
                        .italic()
                        .padding(.vertical, Constants.Padding.emptyTextVertical)
                        .frame(maxWidth: .infinity)
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(toBuyItems) { toBuyItem in
                            
                            TaskListItemView(taskItem: toBuyItem,
                                             schedules: toBuyItem.dailySchedulesList)
                                .onLongPressGesture {
                                    editTaskItem(toBuyItem)
                                }
                            
                            if toBuyItem != toBuyItems.last {
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
        ToBuyItemsListView(editTaskItem: { _ in })
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.gray)
}
