//
//  CurrencyViewModel.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-24.
//

import Foundation

@MainActor
final class CurrencyViewModel: ObservableObject {
    
    @Published var amount: String = ""
    @Published var fromCurrency: Currency = .USD
    @Published var toCurrency: Currency = .AUD
    @Published var convertedAmount: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: CurrencyServiceProtocol
    
    init(service: CurrencyServiceProtocol = CurrencyService()) {
        self.service = service
    }
    
    // MARK: - Validation
    
    var isAmountValid: Bool {
        guard let value = Double(amount), value > 0 else {
            return false
        }
        return true
    }
    
    var isCurrencySelectionValid: Bool {
        fromCurrency != toCurrency
    }
    
    var canConvert: Bool {
        isAmountValid && isCurrencySelectionValid && !isLoading
    }
    
    // MARK: - Actions
    
    func swapCurrencies() {
        (fromCurrency, toCurrency) = (toCurrency, fromCurrency)
    }
    
    func convert() {
        guard !amount.isEmpty else { return }
        
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let result = try await service.convert(
                    from: fromCurrency,
                    to: toCurrency,
                    amount: amount
                )
                
                convertedAmount = String(
                    format: "%.2f %@", result, toCurrency.rawValue
                )
            } catch {
                errorMessage = "Conversion failed"
            }
            
            isLoading = false
        }
    }
    
    private func setValidationError() {
        if !isAmountValid {
            errorMessage = "Please enter a valid amount"
        } else if !isCurrencySelectionValid {
            errorMessage = "From and To currencies must be different"
        }
    }
}
