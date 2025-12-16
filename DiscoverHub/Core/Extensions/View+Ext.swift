//
//  View+Ext.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-16.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
