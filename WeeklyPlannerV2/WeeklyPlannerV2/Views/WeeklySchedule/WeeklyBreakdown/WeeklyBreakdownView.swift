//
//  WeeklyBreakdownView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-07.
//

import SwiftUI

struct WeeklyBreakdownView: View {

    private enum Constants {
        enum Padding {
            static let condensedToggleView: CGFloat = 20
            static let headerHorizontal: CGFloat = 10
            static let titleHorizontal: CGFloat = 22
            static let top: CGFloat = 100
            static let weekdayButtonsBottom: CGFloat = 15
            static let weekdayButtonsTop: CGFloat = 15
        }
        enum Sizing {
            static let headerButtonSize: CGFloat = 45
        }
        enum Spacing {
            static let headerVertical: CGFloat = 20
            static let headerButtonSpacing: CGFloat = 20
        }
    }
    
    @StateObject private var viewModel: WeeklyBreakdownViewModel
    private let weeklySchedule: WeeklySchedule
    
    @State private var themeColour: Color
    @State private var showCompactSchedules: Bool = false
    
    init(weeklySchedule: WeeklySchedule) {
        
        _viewModel = .init(wrappedValue: .init(weeklySchedule: weeklySchedule))
        self.weeklySchedule = weeklySchedule
        self.themeColour = AppColours.getColourForWeeklySchedule(weeklySchedule)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                header
                
                compactSchedulesToggleView
                    .padding(Constants.Padding.condensedToggleView)
                
                // Display daily schedules as a kind of stack where Monday is at the top and Sunday is at the bottom
                TabView(selection: $viewModel.selectedWeekdayIndex) {
                    ForEach(Array(viewModel.dailySchedules.enumerated()), id: \.offset) { index, dailySchedule in
                        Group {
                            if showCompactSchedules {
                                CompactDailyScheduleView(dailySchedule: dailySchedule)
                            } else {
                                ExpandedDailyScheduleView(dailySchedule: dailySchedule)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .animation(.easeIn(duration: 0.3), value: showCompactSchedules)
            .onAppear {
                reloadViews()
            }
        }
    }
    
    private func reloadViews() {
        
        showCompactSchedules = viewModel.getShowCompactDailySchedules()
        themeColour = AppColours.getColourForWeeklySchedule(weeklySchedule)
    }
}


// MARK: - Subviews


extension WeeklyBreakdownView {
    
    private var header: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            Text(viewModel.title)
                .font(AppFonts.title)
            
            weekdayButtonsView
                .padding(EdgeInsets(top: Constants.Padding.weekdayButtonsTop,
                                    leading: Constants.Padding.headerHorizontal,
                                    bottom: Constants.Padding.weekdayButtonsBottom,
                                    trailing: Constants.Padding.headerHorizontal))
            
            Divider()
                .background(AppColours.offBlack)
        }
        .background(.white)
        .frame(height: Constants.Padding.top)
    }
    
    private var weekdayButtonsView: some View {
        HStack(spacing: 0) {
            
            let gradient = RadialGradient(colors: [themeColour.opacity(0.8), themeColour], center: .center, startRadius: 1, endRadius: 20)
            
            ForEach(Weekday.allCases) { weekday in
                
                let weekdayIndex = weekday.rawValue
                let isSelected = viewModel.selectedWeekdayIndex == weekdayIndex
                
                Button {
                    withAnimation {
                        viewModel.selectWeekday(atIndex: weekdayIndex)
                    }
                } label: {
                    if isSelected {
                        Text(weekday.shortName)
                            .tint(.white)
                            .frame(width: Constants.Sizing.headerButtonSize,
                                   height: Constants.Sizing.headerButtonSize)
                            .background(gradient)
                            .font(AppFonts.detailLabelBold)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.headerButtonSize / 2))
                            .shadow(color: AppColours.shadowColour, radius: 4, x: 2, y: 2)
                    } else {
                        Text(weekday.shortName)
                            .tint(.black)
                            .frame(width: Constants.Sizing.headerButtonSize,
                                   height: Constants.Sizing.headerButtonSize)
                            .background(.white)
                            .font(AppFonts.detailLabelBold)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.headerButtonSize / 2))
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var compactSchedulesToggleView: some View {
        HStack {
            Text("Compact view")
                .font(AppFonts.detailLabelMedium)
                .layoutPriority(1)
            
            Spacer()
            
            Toggle("", isOn: $showCompactSchedules)
                .tint(themeColour)
            .onChange(of: showCompactSchedules) { _, newValue in
                viewModel.toggleShowCompactDailySchedules(to: newValue)
            }
        }
    }
}


// MARK: - Previews


struct WeeklyBreadownView_Previews: PreviewProvider {
    
    static let previewContext = PersistenceController.preview.container.viewContext
    static let weeklySchedule = PersistenceController.createMockWeeklySchedule(moc: previewContext)
    
    static var previews: some View {
        WeeklyBreakdownView(weeklySchedule: weeklySchedule)
            .environment(\.managedObjectContext, previewContext)
    }
}
