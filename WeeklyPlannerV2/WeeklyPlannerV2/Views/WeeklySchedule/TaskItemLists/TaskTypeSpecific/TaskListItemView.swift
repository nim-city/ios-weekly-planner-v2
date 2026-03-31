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

struct TaskListItemView<S: Schedulable>: View {
    
    let taskItem: TaskItem
    let schedules: [S]
    
    @State var isExpanded: Bool = false
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
    
    init(taskItem: TaskItem, schedules: [S]) {
        self.taskItem = taskItem
        self.schedules = schedules
        self.completed = taskItem.completed
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
            .padding(Constants.Padding.mainAllAround)
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
                        .background(colour.opacity(0.5))
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
