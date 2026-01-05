//
//  CurrencyViewModel.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-24.
//

import Foundation
import Combine

@MainActor
final class CurrencyViewModel: ObservableObject {
    
    @Published var amount: String = ""
    @Published var fromCurrency: Currency = .USD
    @Published var toCurrency: Currency = .AUD
    @Published var convertedAmount: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: CurrencyServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: CurrencyServiceProtocol = CurrencyService()) {
        self.service = service
        setupPipeline()
    }
    
    private func setupPipeline() {
        // Combine inputs: Amount, From, To
        Publishers.CombineLatest3($amount, $fromCurrency, $toCurrency)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates { prev, curr in
                prev.0 == curr.0 && prev.1 == curr.1 && prev.2 == curr.2
            }
            .sink { [weak self] (amt, from, to) in
                self?.handleInput(amount: amt, from: from, to: to)
            }
            .store(in: &cancellables)
    }
    
    private func handleInput(amount: String, from: Currency, to: Currency) {
        guard !amount.isEmpty, let value = Double(amount), value > 0 else {
            self.convertedAmount = nil
            self.errorMessage = nil
            self.isLoading = false
            return
        }
        
        guard from != to else {
            self.convertedAmount = String(format: "%.2f %@", value, to.rawValue)
            self.errorMessage = nil
            self.isLoading = false
            return
        }
        
        // Trigger conversion
        Task {
            await self.convert(amount: amount, from: from, to: to)
        }
    }
    
    private func convert(amount: String, from: Currency, to: Currency) async {
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let result = try await service.convert(
                from: from,
                to: to,
                amount: amount
            )
            
            self.convertedAmount = String(
                format: "%.2f %@", result, to.rawValue
            )
        } catch {
            self.errorMessage = "Conversion failed. Please try again."
        }
        
        self.isLoading = false
    }
    
    func swapCurrencies() {
        (fromCurrency, toCurrency) = (toCurrency, fromCurrency)
    }
}
