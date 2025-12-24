//
//  CurrencyService.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-25.
//

import Foundation

protocol CurrencyServiceProtocol {
    func convert(
        from: Currency,
        to: Currency,
        amount: String
    ) async throws -> Double
}

final class CurrencyService: CurrencyServiceProtocol {
    
    private let client: APIClient
    
    init(client: APIClient = NetworkManager.shared) {
        self.client = client
    }
    
    func convert(from: Currency, to: Currency, amount: String) async throws -> Double {
        let endPoint = CurrencyEndPoint.convert(
            from: from.rawValue,
            to: to.rawValue,
            amount: amount
        )
        
        let response: CurrencyResponse = try await client.request(endPoint)
        
        guard let result = response.rates[to.rawValue] else {
            throw NetworkError.invalidResponse
        }
        return result
    }
    
}
