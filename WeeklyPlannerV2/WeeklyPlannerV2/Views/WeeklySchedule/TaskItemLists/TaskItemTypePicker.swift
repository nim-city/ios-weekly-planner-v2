//
//  TaskItemTypePicker.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-13.
//

import SwiftUI

extension TaskItemListsView {
    
    struct TaskItemTypePicker: View {
        
        @Binding var selectedTaskItemType: TaskItemType
        
        var body: some View {
            // -2 spacing to push buttons closer together
            HStack(alignment: .bottom, spacing: -2) {
                ForEach(TaskItemType.allCases, id: \.self) { taskItemType in
                    TaskItemTypePickerButton(taskItemType: taskItemType,
                                             selectedTaskItemType: $selectedTaskItemType)
                }
            }
        }
        
        // MARK: Picker button
        
        private struct TaskItemTypePickerButton: View {
            
            private enum Constants {
                enum Padding {
                    
                }
                enum Spacing {
                    static let shadowYOffset: CGFloat = -10
                }
                // FIXME: At some point, replace UIScreen.main.bounds.size.width
                enum Sizing {
                    static let cornerRadius: CGFloat = 10
                    static let borderWidth: CGFloat = 2
                    static let selectedHeight: CGFloat = 50
                    static let selectedWidth: CGFloat = (UIScreen.main.bounds.size.width / 5) + 20
                    static let shadowRadius: CGFloat = 12
                    static let unselectedHeight: CGFloat = 40
                    static let unselectedWidth: CGFloat = (UIScreen.main.bounds.size.width / 5) - 2
                }
            }
            
            let taskItemType: TaskItemType
            @Binding var selectedTaskItemType: TaskItemType
            
            private var isSelected: Bool {
                return taskItemType == selectedTaskItemType
            }
            
            private var backgroundColour: LinearGradient {
                return LinearGradient(colors: [AppColours.getColourForTaskItemType(taskItemType).opacity(0.4), AppColours.getColourForTaskItemType(taskItemType).opacity(0.3)],
                                      startPoint: .top,
                                      endPoint: .bottom)
            }
            
            var body: some View {
                ZStack {
                    
                    Text(getTaskItemTypeLabel(forType: taskItemType))
                        .font(isSelected ? AppFonts.tabBarSelected : AppFonts.tabBarUnselected)
                        .frame(width: isSelected ? Constants.Sizing.selectedWidth : Constants.Sizing.unselectedWidth,
                               height: isSelected ? Constants.Sizing.selectedHeight : Constants.Sizing.unselectedHeight)
                        .background(.white)
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: Constants.Sizing.cornerRadius, topTrailingRadius: Constants.Sizing.cornerRadius))
                  
                    Text(getTaskItemTypeLabel(forType: taskItemType))
                        .font(isSelected ? AppFonts.tabBarSelected : AppFonts.tabBarUnselected)
                        .frame(width: isSelected ? Constants.Sizing.selectedWidth : Constants.Sizing.unselectedWidth,
                               height: isSelected ? Constants.Sizing.selectedHeight : Constants.Sizing.unselectedHeight)
                        .background(backgroundColour)
                        .overlay {
                            TopCurvedBorder(cornerRadius: Constants.Sizing.cornerRadius, shouldDrawBottom: !isSelected)
                                .stroke(AppColours.offBlack, lineWidth: Constants.Sizing.borderWidth * 2)
                        }
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: Constants.Sizing.cornerRadius, topTrailingRadius: Constants.Sizing.cornerRadius))
                        
                        .onTapGesture {
                            selectedTaskItemType = taskItemType
                        }
                }
                .compositingGroup()
                .shadow(color: AppColours.lightShadowColour, radius: Constants.Sizing.shadowRadius, y: Constants.Spacing.shadowYOffset)
            }
            
            private func getTaskItemTypeLabel(forType taskItemType: TaskItemType) -> String {
                switch taskItemType {
                case .goal, .meal, .workout:
                    return taskItemType.shortDisplayValue + "s"
                case .toBuyItem, .toDoItem:
                    return taskItemType.shortDisplayValue
                }
            }
        }
    }
}


// MARK: - Subviews


extension TaskItemListsView.TaskItemTypePicker {
    
    struct TopCurvedBorder: Shape {
        
        let cornerRadius: CGFloat
        let shouldDrawBottom: Bool
        
        func path(in rect: CGRect) -> Path {
            
            var path = Path()
            
            // Bottom left
            path.move(to: .init(x: rect.minX, y: rect.maxY))
            // Top left
            path.addLine(to: .init(x: rect.minX, y: rect.minY + cornerRadius))
            // Top left curve
            path.addArc(center: .init(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(270),
                        clockwise: false)
            // Top right
            path.addLine(to: .init(x: rect.maxX - cornerRadius, y: rect.minY))
            // Top right curve
            path.addArc(center: .init(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(270),
                        endAngle: .degrees(0),
                        clockwise: false)
            // Bottom right
            path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
            
            // Bottom line if necesssary
            if shouldDrawBottom {
                path.addLine(to: .init(x: rect.minX, y: rect.maxY))
            }
            
            return path
        }
    }
}


// MARK: - Previews


#Preview {
    @Previewable @State var selection: TaskItemType = .goal
    
    VStack {
        TaskItemListsView.TaskItemTypePicker(selectedTaskItemType: $selection)
    }
    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    .background(.white)
}
