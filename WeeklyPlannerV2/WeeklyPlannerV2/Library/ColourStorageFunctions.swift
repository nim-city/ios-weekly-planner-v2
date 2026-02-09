//
//  ColourStorageFunctions.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2026-01-18.
//

import SwiftUI

extension Color {
    
    func encodeToData() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: UIColor(self),
                                          requiringSecureCoding: false)
    }
    
    static func decodeFromData(_ data: Data) -> Color? {
        
        guard let colour = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            return nil
        }
        return Color(colour)
    }
}
