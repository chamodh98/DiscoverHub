//
//  CurrencyResponse.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-25.
//

import Foundation

struct CurrencyResponse: Decodable {
    let amount: Double
    let base: String
    let rates: [String: Double]
}
