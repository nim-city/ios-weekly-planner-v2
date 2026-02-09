//
//  FloatingAddButton.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-01.
//

import SwiftUI

struct FloatingAddButtonView: View {
    
    private enum Constants {
        enum ImageName {
            static let plus: String = "plus"
        }
        enum Sizing {
            static let buttonFont: CGFloat = 40
            static let buttonSize: CGFloat = 60
            static let shadowOffset: CGFloat = 2
            static let shadowRadius: CGFloat = 5
        }
    }
    
    let action: () -> Void
    
    private let backgroundColour = RadialGradient(colors: [AppColours.offBlack, .black],
                                                  center: .center,
                                                  startRadius: 10,
                                                  endRadius: 60)
    
    var body: some View {
        Button(action: action) {
            ZStack {
                
                Circle()
                    .frame(width: Constants.Sizing.buttonSize, height: Constants.Sizing.buttonSize)
                    .foregroundStyle(backgroundColour)
                
                Image(systemName: Constants.ImageName.plus)
                    .font(.system(size: Constants.Sizing.buttonFont, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .shadow(color: AppColours.offBlack, radius: Constants.Sizing.shadowRadius, x: Constants.Sizing.shadowOffset, y: Constants.Sizing.shadowOffset)
    }
}


#Preview {
    VStack {
        Color.white
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .overlay(alignment: .bottomTrailing) {
        FloatingAddButtonView(action: {})
            .padding(.trailing, 40)
            .padding(.bottom, 40)
    }
}
