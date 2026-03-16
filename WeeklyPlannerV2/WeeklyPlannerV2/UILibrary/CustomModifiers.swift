//
//  CustomModifiers.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-03-15.
//

import SwiftUI

extension View {
    
    func bottomRightShadow() -> some View {
        self.shadow(radius: 8, x: 4, y: 4)
    }
}
