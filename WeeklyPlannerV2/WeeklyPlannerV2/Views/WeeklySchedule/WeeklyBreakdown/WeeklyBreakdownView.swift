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
    
    private var themeColour: Color {
        AppColours.getColourForWeeklySchedule(weeklySchedule)
    }
    
    init(weeklySchedule: WeeklySchedule) {
        
        _viewModel = .init(wrappedValue: .init(weeklySchedule: weeklySchedule))
        self.weeklySchedule = weeklySchedule
    }
    
    var body: some View {
        NavigationStack {
            
            // Display daily schedules as a kind of stack where Monday is at the top and Sunday is at the bottom
            if let dailySchedule = viewModel.currentDailySchedule {
                
                DailyScheduleView(dailySchedule: dailySchedule)
                    .padding(.top, Constants.Padding.top)
                
                // Header
                .overlay(alignment: .top) {
                    header
                }
            }
        }
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
            ForEach(Weekday.allCases) { weekday in
                
                let weekdayIndex = weekday.rawValue
                let isSelected = viewModel.selectedWeekdayIndex == weekdayIndex
                let gradient = RadialGradient(colors: [themeColour.opacity(0.8), themeColour], center: .center, startRadius: 1, endRadius: 20)
                
                Button {
                    viewModel.selectWeekday(atIndex: weekdayIndex)
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
