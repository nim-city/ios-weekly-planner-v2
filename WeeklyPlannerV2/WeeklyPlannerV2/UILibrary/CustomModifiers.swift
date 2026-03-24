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

struct SunkenStyle: ViewModifier {
    var cornerRadius: CGFloat = 16
    var shadowRadius: CGFloat = 4
    var offset: CGFloat = 2
    var lightColor: Color = .white.opacity(0.7)
    var darkColor: Color = .black.opacity(0.3)
    var backgroundColor: Color = Color(.systemGray6)

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius)

        content
            .background(
                shape.fill(backgroundColor)
            )
            .overlay(
                shape.stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            // dark inner shadow
            .overlay(
                shape
                    .stroke(darkColor, lineWidth: shadowRadius)
                    .blur(radius: shadowRadius)
                    .offset(x: offset, y: offset)
                    .mask(shape)
            )
            // light inner highlight
            .overlay(
                shape
                    .stroke(lightColor, lineWidth: shadowRadius)
                    .blur(radius: shadowRadius)
                    .offset(x: -offset, y: -offset)
                    .mask(shape)
            )
    }
}
