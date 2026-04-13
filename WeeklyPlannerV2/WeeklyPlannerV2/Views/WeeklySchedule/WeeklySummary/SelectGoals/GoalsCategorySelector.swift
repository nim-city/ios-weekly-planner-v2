//
//  GoalsCategorySelector.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-04-13.
//

import SwiftUI

extension SelectGoalsView {
    
    struct GoalsCategorySelector: View {
        
        private enum Constants {
            enum Sizing {
                static let cornerRadius: CGFloat = 16
                static let buttonHeight: CGFloat = 40
            }
        }
        
        private let goalCategories: [GoalCategory] = [.daily, .weekly]
        
        @Binding var selectedCategory: GoalCategory
        
        private var backgroundGradient: LinearGradient {
            .init(colors: [
                .goalDarkened,
                .goalDarkened.opacity(0.8),
                .goalDarkened,
            ], startPoint: .top, endPoint: .bottom)
        }
        
        var body: some View {
            HStack(spacing: 0) {
                
                ForEach(goalCategories, id: \.self) { category in
                    
                    Group {
                        if category == selectedCategory {
                            Text(category.displayValue.capitalized)
                                .font(AppFonts.detailLabelBold)
                                .foregroundStyle(.white)
                                .frame(height: Constants.Sizing.buttonHeight)
                                .frame(maxWidth: .infinity)
                                .background(backgroundGradient)
                        } else {
                            Text(category.displayValue.capitalized)
                                .font(AppFonts.detailLabelBold)
                                .foregroundStyle(.tint)
                                .frame(height: Constants.Sizing.buttonHeight)
                                .frame(maxWidth: .infinity)
                                .background(.white)
                        }
                    }
                    .onTapGesture {
                        self.selectedCategory = category
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizing.cornerRadius))
            .tint(.goalDarkened)
            .bottomRightShadow()
        }
    }
}
