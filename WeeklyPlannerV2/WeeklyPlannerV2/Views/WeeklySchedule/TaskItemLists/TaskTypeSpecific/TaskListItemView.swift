//
//  TaskListItemView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-15.
//

import SwiftUI


// Annoying but this must be placed outside of the struct because of the generic S: Schedulable
private enum Constants {
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
        static let mainVertical: CGFloat = 16
        static let notesVertical: CGFloat = 10
        static let topViewHorizontal: CGFloat = 4
        static let weekdayButtons: CGFloat = 12
    }
}

struct TaskListItemView<S: Schedulable>: View {
    
    let taskItem: TaskItem
    let taskItemType: TaskItemType
    let schedules: [S]
    let roundTop: Bool
    let roundBottom: Bool
    let showDivider: Bool
    
    @Binding var isExpanded: Bool
    @State var completed: Bool = false
    
    private var priorityColor: Color? {
        
        var priority: Int16?
        if let toBuyItem = taskItem as? ToBuyItem {
            priority = toBuyItem.priority
        } else if let toDoItem = taskItem as? ToDoItem {
            priority = toDoItem.priority
        }
        
        switch priority {
        case 1:
            return Color.red
        case 2:
            return Color.blue
        default:
            return nil
        }
    }
    
    init(taskItem: TaskItem, taskItemType: TaskItemType, schedules: [S], roundTop: Bool, roundBottom: Bool, showDivider: Bool, isExpanded: Binding<Bool>) {
        
        self.taskItem = taskItem
        self.taskItemType = taskItemType
        self.completed = taskItem.completed
        self.schedules = schedules
        self.roundTop = roundTop
        self.roundBottom = roundBottom
        self.showDivider = showDivider
        self._isExpanded = isExpanded
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
                    
                    if let colour = priorityColor {
                        Image(systemName: "flag.fill")
                            .foregroundStyle(colour)
                            .font(AppFonts.iconSmall)
                    }
                }
                
                // Weekly schedules view
                if !schedules.isEmpty {
                    schedulesListView
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
                } else {
                    Text("No notes yet")
                        .italic()
                }
            }
            .font(AppFonts.infoLabel)
            .padding(.leading, Constants.Padding.subviewsLeading)
        }
    }
    
    private var schedulesListView: some View {
        ScrollView([.horizontal]) {
            HStack(spacing: 8) {
                
                ForEach(schedules, id: \.self) { schedule in
                    
                    let colour = getColourForSchedulable(schedule)

                    Text(schedule.scheduleName)
                        .font(.system(size: 12, weight: .semibold))
                        .padding(.horizontal, 8)
                        .frame(height: 20)
                        .background(colour.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    private func getColourForSchedulable(_ schedulable: S) -> Color {
        
        if let weeklySchedule = schedulable.weeklySchedule,
           let colourData = weeklySchedule.colourData,
           let colour = Color.decodeFromData(colourData) {
            
            return colour
        }
        
        return AppColours.appTheme
    }
}


// MARK: - Previews


struct TaskListView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        TaskItemListsView(weeklySchedule: weeklySchedule)
            .environment(\.managedObjectContext, previewContext)
    }
}
