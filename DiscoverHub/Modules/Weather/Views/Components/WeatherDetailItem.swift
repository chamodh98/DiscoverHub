//
//  WeatherDetailItem.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-31.
//

import SwiftUI

struct WeatherDetailItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                        .padding(8)
                        .background(color.opacity(0.15))
                        .clipShape(Circle())
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(value)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                }
            }
        }
    }
}

#Preview {
    HStack {
        WeatherDetailItem(
            icon: "wind",
            title: "Wind Speed",
            value: "12 km/h",
            color: .blue
        )
        WeatherDetailItem(
            icon: "humidity",
            title: "Humidity",
            value: "58%",
            color: .teal
        )
    }
    .padding()
}
