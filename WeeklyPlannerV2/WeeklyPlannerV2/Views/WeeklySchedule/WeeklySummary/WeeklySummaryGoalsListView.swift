//
//  WeeklySummaryGoalsListView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-11-14.
//

import SwiftUI

extension WeeklySummaryView {
    
    struct GoalsList: View {
        
        private enum Constants {
            enum ImageName {
                static let plus = "plus"
            }
            enum Padding {
                static let dividerHorizontal: CGFloat = 14
                static let text: CGFloat = 16
            }
            enum Sizing {
                static let borderWidth: CGFloat = 2
                static let cornerRadius: CGFloat = 20
            }
            enum Spacing {
                static let headerHorizontal: CGFloat = 16
                static let mainVertical: CGFloat = 10
            }
        }
        
        let goals: [Goal]
        let category: GoalCategory
        let selectGoalsAction: () -> Void
        let editGoalAction: (Goal) -> Void
        
        var title: String {
            switch category {
            case .daily:
                return "Daily goals"
            case .weekly:
                return "Weekly goals"
            case .longTerm:
                return "Long term goals"
            }
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.mainVertical) {
                
                header
                
                Group {
                    if goals.isEmpty {
                        
                        Text("No goals yet")
                            .font(AppFonts.detailLabel)
                            .italic()
                            .padding(Constants.Padding.text)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                            .overlay {
                                RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                                    .stroke(.tint, lineWidth: Constants.Sizing.borderWidth)
                            }
                    } else {
                        
                        VStack(spacing: 0) {
                            
                            ForEach(goals) { goal in
                                
                                GoalsListItem(goal: goal)
                                    .onLongPressGesture {
                                        editGoalAction(goal)
                                    }
                                
                                if goal != goals.last {
                                    Divider()
                                        .background(AppColours.dividerBold)
                                        .padding(.horizontal, Constants.Padding.dividerHorizontal)
                                }
                            }
                        }
                    }
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                        .stroke(.black, lineWidth: Constants.Sizing.borderWidth)
                }
            }
        }
        
        private var header: some View {
            HStack(spacing: Constants.Spacing.headerHorizontal) {
                
                Text(title)
                    .font(AppFonts.subtitle)
                
                Button {
                    selectGoalsAction()
                } label: {
                    Image(systemName: Constants.ImageName.plus)
                        .font(AppFonts.detailLabelBold)
                        .foregroundStyle(.tint)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    
    // MARK: - Subviews
    
    
    private struct GoalsListItem: View {
        
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
            enum Sizing {
                static let weekdayButtonBorder: CGFloat = 1
                static var weekdayButtonCornerRadius: CGFloat {
                    weekdayButtonSize / 2
                }
                static let weekdayButtonSize: CGFloat = 24
            }
        }
        
        @Environment(\.managedObjectContext) private var moc
        
        let goal: Goal
        
        @State var completed: Bool = false
        @State var weekdaysCompleted: [Weekday] = []
        @State var isExpanded: Bool = false
        
        var showCompletedCheckbox: Bool {
            goal.category == .weekly
        }
        
        var showDaysCompletedView: Bool {
            goal.category == .daily
        }
        
        init(goal: Goal) {
            
            self.goal = goal
            self.completed = goal.completed
            self.weekdaysCompleted = goal.weekdaysCompleted
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Spacing.mainVertical) {
                HStack(spacing: Constants.Spacing.topViewHorizontal) {
                    
                    // Name label
                    Text(goal.name ?? "Goal")
                        .font(AppFonts.detailLabelMedium)
                        .lineLimit(1)
                    
                    // Expand button
                    ExpandCollapseButton(isExpanded: $isExpanded)
                    
                    Spacer()
                    
                    // Is selected checkbox
                    if showCompletedCheckbox {
                        Checkbox(isSelected: $completed)
                    }
                }
                
                if isExpanded {
                    
                    // Completed view
                    if showDaysCompletedView {
                        completedWeekdayView
                            .padding(.leading, Constants.Padding.subviewsLeading)
                    }
                    
                    // Notes view
                    notesView
                }
            }
            .padding(Constants.Padding.mainAllAround)
            .contentShape(Rectangle())
            .onChange(of: weekdaysCompleted) {
                
                goal.updateWeekdaysCompleted(to: weekdaysCompleted)
                save()
            }
        }
        
        private var completedWeekdayView: some View {
            HStack(spacing: Constants.Spacing.weekdayButtons) {
                
                ForEach(Weekday.allCases) { weekday in
                    
                    let isSelected = getIsWeekdaySelected(weekday)
                    Button {
                        
                        selectWeekday(weekday)
                    } label: {
                        if isSelected {
                            Text(weekday.initial)
                                .foregroundStyle(.white)
                                .frame(width: Constants.Sizing.weekdayButtonSize,
                                       height: Constants.Sizing.weekdayButtonSize)
                                .background(.tint)
                        } else {
                            Text(weekday.initial)
                                .foregroundStyle(.black)
                                .frame(width: Constants.Sizing.weekdayButtonSize,
                                       height: Constants.Sizing.weekdayButtonSize)
                                .background(.white)
                        }
                    }
                    .font(AppFonts.buttonSmall)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.weekdayButtonCornerRadius))
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.Sizing.weekdayButtonCornerRadius)
                            .stroke(.black, lineWidth: Constants.Sizing.weekdayButtonBorder)
                    }
                }
                
                Spacer()
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
                    if let notes = goal.notes, !notes.isEmpty {
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
        
        private func getIsWeekdaySelected(_ weekday: Weekday) -> Bool {
            weekdaysCompleted.contains(weekday)
        }
        
        private func selectWeekday(_ weekday: Weekday) {
            
            if let index = weekdaysCompleted.firstIndex(of: weekday) {
                weekdaysCompleted.remove(at: index)
            } else {
                weekdaysCompleted.append(weekday)
            }
            
            goal.updateWeekdaysCompleted(to: weekdaysCompleted)
            save()
        }
        
        private func save() {
            do {
                try moc.save()
            } catch let error {
                // Fail silently for now
                print(error)
            }
        }
    }
}


// MARK: - Previews


struct WeeklySummaryGoalsListView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        WeeklySummaryView(weeklySchedule: weeklySchedule)
            .environment(\.managedObjectContext, previewContext)
    }
}
