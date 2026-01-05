//
//  CurrencyPickerRow.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-25.
//

import SwiftUI

struct CurrencyPickerRow: View {
    let title: String
    @Binding var selection: Currency
    
    var body: some View {
        AppCard {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Picker(title, selection: $selection) {
                    ForEach(Currency.allCases) {
                        Text("\($0.rawValue) - \($0.name)")
                            .tag($0)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden() // Hide default label 
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    @State var currency: Currency = .AUD
    CurrencyPickerRow(title: "Currency", selection: $currency)
}
