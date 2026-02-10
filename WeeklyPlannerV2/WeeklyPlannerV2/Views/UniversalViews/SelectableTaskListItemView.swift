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
            static let mainAllAround: CGFloat = 16
            static let notesLabelHorizontal: CGFloat = 8
            static let subviewsLeading: CGFloat = 8
        }
        enum Spacing {
            static let mainVertical: CGFloat = 16
            static let notesVertical: CGFloat = 10
            static let topViewHorizontal: CGFloat = 4
            static let weekdayButtons: CGFloat = 12
        }
    }
            
    let taskItem: TaskItem
    let isSelected: Bool
    let onTap: () -> Void
    
    @State var isExpanded: Bool = false
    
    var body: some View {
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
        .padding(Constants.Padding.mainAllAround)
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
                if let notes = taskItem.notes, !notes.isEmpty {
                    Text(notes)
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
