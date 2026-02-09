//
//  AppAnimations.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-01-17.
//

import UIKit
import SwiftUI

class AppAnimations {
    
    static func makeLongPressFeedback() {
        let longPressVibration: UIImpactFeedbackGenerator = .init(style: .medium)
        longPressVibration.impactOccurred()
    }
    
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private init() {}
}


//// MARK: - SwiftUI specific animations
//
//
//extension View {
//    
//    func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
