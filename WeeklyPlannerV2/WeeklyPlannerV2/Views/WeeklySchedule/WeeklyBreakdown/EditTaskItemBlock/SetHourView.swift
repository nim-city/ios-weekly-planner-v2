//
//  SetHourView.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-01-29.
//

import SwiftUI

extension AddEditTaskBlockView {
    
    struct SetHourView: View {
        
        private enum Constants {
            enum Padding {
                static let horizontal: CGFloat = 15
                static let vertical: CGFloat = 10
            }
            enum Sizing {
                static let arrowButtonLength: CGFloat = 14
                static let borderWidth: CGFloat = 1
                static let cornerRadius: CGFloat = 12
            }
            enum Spacing {
                static let horizontal: CGFloat = 10
            }
        }
        
        let title: String
        let hourString: String
        let increaseHourAction: () -> Void
        let decreaseHourAction: () -> Void
        
        var body: some View {
            HStack {
                
                Text(title)
                    .font(AppFonts.formHeading)
                
                Spacer()
                
                HStack(spacing: Constants.Spacing.horizontal) {
                    
                    Button {
                        decreaseHourAction()
                    } label: {
                        Image(systemName: "arrowtriangle.left.square")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    
                    Text(hourString)
                        .font(AppFonts.controlLabel)
                    
                    Button {
                        increaseHourAction()
                    } label: {
                        Image(systemName: "arrowtriangle.right.square")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                .padding(.horizontal, Constants.Padding.horizontal)
                .padding(.vertical, Constants.Padding.vertical)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius)
                        .stroke(.tint, lineWidth: Constants.Sizing.borderWidth)
                }
            }
        }
    }
}
