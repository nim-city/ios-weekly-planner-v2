//
//  SelectableTaskListItemView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-01-11.
//

import SwiftUI

struct SelectableTaskItemView: View {
    
    private enum Constants {
        enum ImageName {
            static let selected: String = "checkmark.circle.fill"
            static let unselected: String = "circle"
        }
        enum Padding {
            static let expandedVertical: CGFloat = 8
            static let largePadding: CGFloat = 20
            static let notesLabelHorizontal: CGFloat = 8
            static let smallPadding: CGFloat = 14
            static let subviewsLeading: CGFloat = 8
        }
        enum Sizing {
            static let cornerRadius: CGFloat = 20
        }
        enum Spacing {
            static let mainVertical: CGFloat = 12
            static let notesVertical: CGFloat = 10
            static let topViewHorizontal: CGFloat = 4
            static let weekdayButtons: CGFloat = 12
        }
    }
            
    let taskItem: TaskItem
    let taskItemType: TaskItemType
    let isSelected: Bool
    let onTap: () -> Void
    let roundTop: Bool
    let roundBottom: Bool
    let showDivider: Bool
    
    @Binding var isExpanded: Bool
    
    init(taskItem: TaskItem, taskItemType: TaskItemType, isSelected: Bool, roundTop: Bool, roundBottom: Bool, showDivider: Bool, isExpanded: Binding<Bool>, onTap: @escaping () -> Void) {
        
        self.taskItem = taskItem
        self.taskItemType = taskItemType
        self.isSelected = isSelected
        self.roundTop = roundTop
        self.roundBottom = roundBottom
        self.showDivider = showDivider
        self._isExpanded = isExpanded
        self.onTap = onTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            VStack(alignment: .leading, spacing: Constants.Spacing.mainVertical) {
                HStack(spacing: Constants.Spacing.topViewHorizontal) {
                    
                    // Name label
                    Text(taskItem.name ?? "Task item")
                        .font(AppFonts.detailLabelMedium)
                        .lineLimit(1)
                    
                    // Expand button
                    ExpandCollapseButton(isExpanded: $isExpanded)
                        .buttonStyle(.borderless)
            
                    
                    Spacer()
                    
                    Image(systemName: isSelected ? Constants.ImageName.selected : Constants.ImageName.unselected)
                        .font(AppFonts.controlLabel)
                        .foregroundStyle(.tint)
                }
                
                // Notes view
                if isExpanded {
                    notesView
                }
            }
            
            .padding(isExpanded ? Constants.Padding.largePadding : Constants.Padding.smallPadding)
            .background(.white)
            .scaleEffect(x: isExpanded ? 1.04 : 1,
                         y: isExpanded ? 1.04 : 1)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: roundTop || isExpanded ? Constants.Sizing.cornerRadius : 0,
                                              bottomLeadingRadius: roundBottom || isExpanded ? Constants.Sizing.cornerRadius : 0,
                                              bottomTrailingRadius: roundBottom || isExpanded ? Constants.Sizing.cornerRadius : 0,
                                              topTrailingRadius: roundTop || isExpanded ? Constants.Sizing.cornerRadius : 0))
            .padding(.horizontal, isExpanded ? Constants.Padding.smallPadding : Constants.Padding.largePadding)
            .padding(.vertical, isExpanded ? Constants.Padding.expandedVertical : 0)
            
            if showDivider {
                Divider()
                    .background(AppColours.getColourForTaskItemType(taskItemType))
                    .padding(.horizontal, Constants.Padding.largePadding)
            }
        }
        .onTapGesture {
            withAnimation {
                onTap()
            }
        }
    }
    
    private var notesView: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.notesVertical) {
            
            ZStack {
                Divider()
                    .background(.tint)
                
                Text("Notes")
                    .font(AppFonts.infoLabelMedium)
                    .foregroundStyle(.tint)
                    .padding(.horizontal, Constants.Padding.notesLabelHorizontal)
                    .background(.white)
            }
            
            Group {
                if !taskItem.bulletedNotes.isEmpty {
                    Text(taskItem.bulletedNotes)
                        .lineSpacing(4)
                } else {
                    Text("No notes yet")
                        .italic()
                }
            }
            .font(AppFonts.infoLabel)
            .padding(.leading, Constants.Padding.subviewsLeading)
        }
    }
}
