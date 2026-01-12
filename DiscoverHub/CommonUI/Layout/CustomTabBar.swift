//
//  CustomTabBar.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2026-01-05.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case weather = "Weather"
    case news = "News"
    case currency = "Currency"
    case github = "GitHub"
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .weather: return "sun.max.fill"
        case .news: return "newspaper.fill"
        case .currency: return "dollarsign.circle.fill"
        case .github: return "chevron.left.slash.chevron.right"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @Namespace private var animation
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22))
                            .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                        
                         Text(tab.rawValue)
                             .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.6))
                    .padding(.vertical, 16)
                    .background(
                        ZStack {
                            if selectedTab == tab {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(AppColors.secondary.opacity(0.3))
                                    .matchedGeometryEffect(id: "TabHighlight", in: animation)
                            }
                        }
                    )
                }
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color(uiColor: .systemBackground).opacity(0.1)) // Glass base
                .background(
                    VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
                        .cornerRadius(32)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}


// Helper for Blur Effect
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.home))
        }
    }
}
