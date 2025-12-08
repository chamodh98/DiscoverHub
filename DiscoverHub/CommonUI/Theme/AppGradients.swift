//
//  AppGradients.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-09.
//

import SwiftUI

enum AppGradients {
    static let primary = LinearGradient(
        colors: [
            Color("PrimaryColor"),
            Color("SecondaryColor")
        ],
        startPoint: .topLeading,
        endPoint: .bottomLeading
    )
    
    static let subtleBackground = LinearGradient(
        colors: [
            Color(.systemGray6),
            Color(.systemGray5)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
