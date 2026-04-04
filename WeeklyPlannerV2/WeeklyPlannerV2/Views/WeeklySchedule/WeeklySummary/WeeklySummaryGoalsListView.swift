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
                static let main: CGFloat = 20
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
        
        let weeklySchedule: WeeklySchedule
        let goals: [Goal]
        let category: GoalCategory
        let selectGoalsAction: () -> Void
        let editGoalAction: (Goal) -> Void
        
        @State var expandedListItemIndex: Int? = nil
        
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
                    .padding(.horizontal, Constants.Padding.main)
                
                Group {
                    if goals.isEmpty {
                        
                        ZStack {
                            Color.white
                            
                            Text("No goals yet")
                                .font(AppFonts.detailLabel)
                                .italic()
                                .padding(Constants.Padding.text)
                                .frame(maxWidth: .infinity)
                                .background(.tint.opacity(0.2))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                        .padding(.horizontal, Constants.Padding.main)
                    } else {
                        
                        VStack(spacing: 0) {
                            
                            ForEach(goals.indices, id: \.self) { goalIndex in

                                let goal = goals[goalIndex]
                                let isBelowExpandedItem = goal == goals.first || expandedListItemIndex == goalIndex - 1
                                let isAboveExpandedItem = goal == goals.last || expandedListItemIndex == goalIndex + 1
                                let showDivider = goal != goals.last && !isAboveExpandedItem && goalIndex != expandedListItemIndex
                                
                                GoalsListItem(goal: goal,
                                              weeklySchedule: weeklySchedule,
                                              roundTop: isBelowExpandedItem,
                                              roundBottom: isAboveExpandedItem,
                                              showDivider: showDivider,
                                              isExpanded: Binding(get: { goalIndex == self.expandedListItemIndex },
                                                                  set: {
                                 if $0 {
                                     self.expandedListItemIndex = goalIndex
                                 } else {
                                     self.expandedListItemIndex = nil
                                 }
                             }))
                                .onLongPressGesture {
                                    editGoalAction(goal)
                                }
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                        .bottomRightShadow()
                    }
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
                
                static let expandedVertical: CGFloat = 8
                static let largePadding: CGFloat = 20
                static let mainAllAround: CGFloat = 16
                static let notesLabelHorizontal: CGFloat = 8
                static let smallPadding: CGFloat = 14
                static let subviewsLeading: CGFloat = 8
            }
            enum Sizing {
                static let cornerRadius: CGFloat = 20
                static let dividerHeight: CGFloat = 0.5
                static let weekdayButtonBorder: CGFloat = 1
                static var weekdayButtonCornerRadius: CGFloat {
                    weekdayButtonSize / 2
                }
                static let weekdayButtonSize: CGFloat = 24
            }
            enum Spacing {
                static let mainVertical: CGFloat = 16
                static let notesVertical: CGFloat = 10
                static let topViewHorizontal: CGFloat = 4
                static let weekdayButtons: CGFloat = 12
            }
        }
        
        @Environment(\.managedObjectContext) private var moc
        
        let goal: Goal
        let weeklySchedule: WeeklySchedule
        let roundTop: Bool
        let roundBottom: Bool
        let showDivider: Bool
        
        @State var completed: Bool = false
        @State var weekdaysCompleted: [Weekday] = []
        @Binding var isExpanded: Bool
        
        var showCompletedCheckbox: Bool {
            goal.category == .weekly
        }
        
        var showDaysCompletedView: Bool {
            goal.category == .daily
        }
        init(goal: Goal, weeklySchedule: WeeklySchedule, roundTop: Bool, roundBottom: Bool, showDivider: Bool, isExpanded: Binding<Bool>) {
            
            self.goal = goal
            self.weeklySchedule = weeklySchedule
            self.completed = goal.completed
            self.weekdaysCompleted = goal.weekdaysCompleted
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
                        .background(AppColours.getColourForWeeklySchedule(weeklySchedule))
                        .padding(.horizontal, Constants.Padding.largePadding)
                }
            }
            
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
                        .frame(height: Constants.Sizing.dividerHeight)
                        .background(.tint)
                    
                    Text("Notes")
                        .font(AppFonts.infoLabelMedium)
                        .foregroundStyle(.tint)
                        .padding(.horizontal, Constants.Padding.notesLabelHorizontal)
                        .background(.white)
                }
                
                Group {
                    if !goal.bulletedNotes.isEmpty {
                        Text(goal.bulletedNotes)
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
