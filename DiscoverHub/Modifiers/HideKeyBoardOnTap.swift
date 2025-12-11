//
//  HideKeyBoardOnTap.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-11.
//

import SwiftUI

struct HideKeyBoardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture().onEnded {
                    UIApplication.shared.hideKeyboard()
                }
            )
    }
}

extension View {
    func hideKeyBoardOnTap() -> some View {
        modifier(HideKeyBoardOnTap())
    }
}

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
