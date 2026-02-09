//
//  CustomModifiers.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-01-08.
//

import SwiftUI


// MARK: For adjusting sheet detents
struct HeightPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
