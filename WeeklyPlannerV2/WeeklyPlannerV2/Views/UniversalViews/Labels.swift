//
//  Labels.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-10-18.
//

import SwiftUI

struct TitleLabel: View {
    
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 24, weight: .bold))
    }
}

struct SubtitleLabel: View {
    
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .bold))
    }
}

struct FormHeadingLabel: View {
    
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .medium))
            .foregroundStyle(.tint)
    }
}

struct ScheduleTimeLabel: View {
    
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(AppColours.subduedText)
    }
}

struct InfoLabelLarge: View {
    
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .regular))
    }
}
