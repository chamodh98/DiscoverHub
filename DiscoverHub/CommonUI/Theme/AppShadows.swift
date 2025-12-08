//
//  AppShadows.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-09.
//

import SwiftUI

enum AppShadows {
    static let card = ShadowStyle(
        color: Color.black.opacity(0.1),
        radius: 8,
        x: 0,
        y: 4
    )
}

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

extension View {
    func appShadow(_ style: ShadowStyle) -> some View {
        self.shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}
