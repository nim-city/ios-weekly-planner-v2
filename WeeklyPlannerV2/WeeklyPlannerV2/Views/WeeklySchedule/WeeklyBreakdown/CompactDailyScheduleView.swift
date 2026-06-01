//
//  CompactDailyScheduleView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-05-29.
//

import SwiftUI

struct CompactDailyScheduleView: View {
    
    private enum Constants {
        enum Padding {
            static let mainHorizontal: CGFloat = 20
        }
        enum Spacing {
            static let mainVertical: CGFloat = 10
        }
    }
    
    @Environment(\.managedObjectContext) var moc
    
    let dailySchedule: DailySchedule
    
    @FetchRequest private var taskBlocks: FetchedResults<TaskBlock>
    @State private var taskBlockToEdit: TaskBlock?
    
    init(dailySchedule: DailySchedule) {
        
        self.dailySchedule = dailySchedule
        
        let sortDescriptors = [NSSortDescriptor(key: "startHour", ascending: true)]
        let predicate = NSPredicate(format: "dailySchedule == %@", dailySchedule)
        _taskBlocks = FetchRequest(entity: TaskBlock.entity(), sortDescriptors: sortDescriptors, predicate: predicate)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.Spacing.mainVertical) {
                ForEach(taskBlocks, id: \.self) { taskBlock in
                    CompactTaskBlockView(taskBlock: taskBlock)
                        .onLongPressGesture {
                            longPressTaskBlock(taskBlock)
                        }
                }
            }
            .padding(.horizontal, Constants.Padding.mainHorizontal)
        }
        .scrollIndicators(.hidden)
        
        // Edit task block sheet
        .sheet(item: $taskBlockToEdit) { taskBlock in
            AddEditTaskBlockView(dailySchedule: dailySchedule, startHour: Int(taskBlock.startHour), taskBlock: taskBlock)
        }
    }
    
    private func longPressTaskBlock(_ taskBlock: TaskBlock) {
        
        AppAnimations.makeLongPressFeedback()
        
        taskBlockToEdit = taskBlock
    }
}


// MARK: - Previews


struct CompactDailyScheduleView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        CompactDailyScheduleView(dailySchedule: weeklySchedule.dailySchedulesList.first!)
            .environment(\.managedObjectContext, previewContext)
    }
}
