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
    
    @FetchRequest(sortDescriptors: [.init(keyPath: \ToBuyItem.createdAt, ascending: true),
                                    .init(keyPath: \ToBuyItem.priority, ascending: true)]) private var toBuyItems: FetchedResults<ToBuyItem>
    
    let editTaskItem: (TaskItem) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.mainSpacing) {
                
                // To buy item lists; high priority then low prioritys
                ForEach(ToBuyItemCategory.allCases, id: \.self) { category in
                    
                    let filteredToBuyItems = toBuyItems.filter { $0.categoryName == category.rawValue }
                    ToBuyItemsList(category: category, toBuyItems: filteredToBuyItems, editTaskItem: editTaskItem)
                }
            }
            .padding(.vertical, Constants.mainPadding)
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
        
        let category: ToBuyItemCategory
        let toBuyItems: [ToBuyItem]
        let editTaskItem: (TaskItem) -> Void
        
        @State var expandedListItemIndex: Int? = nil
        
        private var title: String {
            "\(category.displayValue.capitalized)"
        }
        
        private var emptyText: String {
            switch category {
            case .forMe:
                "No personal purchases yet"
            case .forOthers:
                "No purchases for others yet"
            }
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.mainSpacing) {
                
                Text(title)
                    .font(AppFonts.subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, Constants.Padding.main)
                
                if toBuyItems.isEmpty {
                    
                    ZStack {
                        Color.white
                        
                        Text(emptyText)
                            .font(AppFonts.detailLabel)
                            .italic()
                            .padding(.vertical, Constants.Padding.main)
                            .frame(maxWidth: .infinity)
                            .background(AppColours.getColourForTaskItemType(.toBuyItem).opacity(0.2))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                    .padding(.horizontal, Constants.Padding.main)
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(toBuyItems.indices, id: \.self) { toBuyItemIndex in

                            let toBuyItem = toBuyItems[toBuyItemIndex]
                            let isBelowExpandedItem = toBuyItem == toBuyItems.first || expandedListItemIndex == toBuyItemIndex - 1
                            let isAboveExpandedItem = toBuyItem == toBuyItems.last || expandedListItemIndex == toBuyItemIndex + 1
                            let showDivider = toBuyItem != toBuyItems.last && !isAboveExpandedItem && toBuyItemIndex != expandedListItemIndex
                            
                            TaskListItemView(taskItem: toBuyItem,
                                             taskItemType: .toBuyItem,
                                             schedules: toBuyItem.dailySchedulesList,
                                             roundTop: isBelowExpandedItem,
                                             roundBottom: isAboveExpandedItem,
                                             showDivider: showDivider,
                                             isExpanded: Binding(get: { toBuyItemIndex == self.expandedListItemIndex },
                                                                 set: {
                                if $0 {
                                    self.expandedListItemIndex = toBuyItemIndex
                                } else {
                                    self.expandedListItemIndex = nil
                                }
                            }))
                            .onLongPressGesture {
                                editTaskItem(toBuyItem)
                            }
                        }
                        
//                        ForEach(toBuyItems) { toBuyItem in
//                            
//                            TaskListItemView(taskItem: toBuyItem,
//                                             taskItemType: .toBuyItem,
//                                             schedules: toBuyItem.dailySchedulesList,
//                                             isFirst: toBuyItem == toBuyItems.first,
//                                             isLast: toBuyItem == toBuyItems.last)
//                                .onLongPressGesture {
//                                    editTaskItem(toBuyItem)
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
        ToBuyItemsListView(editTaskItem: { _ in })
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.gray)
}
