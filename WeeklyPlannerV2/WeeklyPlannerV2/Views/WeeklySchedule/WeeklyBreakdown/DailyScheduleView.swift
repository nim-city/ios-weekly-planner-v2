//
//  DailyScheduleView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-03.
//

import SwiftUI

struct DailyScheduleView: View {
    
    private enum Constants {
        enum Padding {
            static let leading: CGFloat = 10
            static let mainTop: CGFloat = 25
            static let trailing: CGFloat = 20
        }
        enum Sizing {
            static let listItemHeight: CGFloat = 50
        }
    }
    
    @Environment(\.managedObjectContext) var moc
    
    let dailySchedule: DailySchedule
    
    @FetchRequest private var taskBlocks: FetchedResults<TaskBlock>
    @State var selectedHour: Int?
    @State var isPresentingAddEditTaskBlockView: Bool = false
    
    init(dailySchedule: DailySchedule) {
        
        self.dailySchedule = dailySchedule
        
        let sortDescriptors = [NSSortDescriptor(key: "startHour", ascending: true)]
        let predicate = NSPredicate(format: "dailySchedule == %@", dailySchedule)
        _taskBlocks = FetchRequest(entity: TaskBlock.entity(), sortDescriptors: sortDescriptors, predicate: predicate)
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                
                VStack(spacing: 0) {
                    ForEach(DateTimeFunctions.dailyScheduleHours, id: \.self) { hour in
                        HourBlockView(hour: hour, height: Constants.Sizing.listItemHeight)
                            .onLongPressGesture {
                                longPressHourBlock(forHour: hour)
                            }
                    }
                }
                
                ForEach(taskBlocks, id: \.self) { taskBlock in
                    
                    let offset = CGFloat(taskBlock.startHour) * Constants.Sizing.listItemHeight
                    
                    TaskBlockView(taskBlock: taskBlock, minimumHeight: Constants.Sizing.listItemHeight)
                        .offset(y: offset)
                        .allowsHitTesting(false)
                }
            }
            .padding(.leading, Constants.Padding.leading)
            .padding(.trailing, Constants.Padding.trailing)
            .padding(.top, Constants.Padding.mainTop)
        }
        .scrollIndicators(.hidden)
        
        // Edit task item block view
        .onChange(of: selectedHour) {
            
            if selectedHour != nil {
                isPresentingAddEditTaskBlockView = true
            }
        }
        
        // Edit task block sheet
        .sheet(isPresented: $isPresentingAddEditTaskBlockView) {
            
            selectedHour = nil
        } content: {
            
            if let selectedHour {
                
                let taskBlock = taskBlocks.first(where: { $0.containsHour(selectedHour) })
                AddEditTaskBlockView(dailySchedule: dailySchedule, startHour: selectedHour, taskBlock: taskBlock)
            } else {
                
                EmptyView()
            }
        }
    }
    
    private func longPressHourBlock(forHour hour: Int) {
        
        guard hour < 24 else { return }
        
        AppAnimations.makeLongPressFeedback()
        
        selectedHour = hour
    }
}


// MARK: - Previews


struct DailyScheduleView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        DailyScheduleView(dailySchedule: weeklySchedule.dailySchedulesList.first!)
            .environment(\.managedObjectContext, previewContext)
    }
}
