//
//  CurrencyEndPoint.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-25.
//

import Foundation

enum CurrencyEndPoint {
    static func convert(
        from: String,
        to: String,
        amount: String
    ) -> Endpoint {
        Endpoint(
            baseURL: "https://api.frankfurter.dev",
            path: "/v1/latest",
            method: .get,
            query: [
                "base": from,
                "symbols": to,
                "amount": amount
            ],
            headers: nil
        )
    }
}
