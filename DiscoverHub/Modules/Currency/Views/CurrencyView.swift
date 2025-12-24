//
//  CurrencyView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-08.
//

import SwiftUI

struct CurrencyView: View {
    
    @StateObject private var viewModel = CurrencyViewModel()
    @FocusState private var amountIsForcus: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text("Currency Converter")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Amount Input
                amountInputCard
                
                // Currency Selection
                currencySelectionCard
                
                // Convert Button
                convertButton
                
                if viewModel.isLoading {
                    ProgressView()
                }
                
                // Result
                if let result = viewModel.convertedAmount {
                    resultCard(result: result)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding()
            .onChange(of: viewModel.amount) { _ in
                viewModel.convertedAmount = nil
            }
            .onChange(of: viewModel.fromCurrency) { _ in
                viewModel.convertedAmount = nil
            }
            .onChange(of: viewModel.toCurrency) { _ in
                viewModel.convertedAmount = nil
            }
        }
        .background(AppColors.background)
    }
}

#Preview {
    CurrencyView()
}

private extension CurrencyView {
    var amountInputCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Amount")
                .font(.headline)
            
            TextField("Enter amount", text: $viewModel.amount)
                .focused($amountIsForcus)
                .keyboardType(.decimalPad)
                .font(.title2)
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(12)
        }
    }
}


private extension CurrencyView {
    var currencySelectionCard: some View {
        VStack(spacing: 16) {
            
            CurrencyPickerRow(
                title: "From",
                selection: $viewModel.fromCurrency
            )
            
            Button {
                viewModel.swapCurrencies()
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(AppColors.primary)
                    .clipShape(Circle())
            }
            
            CurrencyPickerRow(
                title: "To",
                selection: $viewModel.toCurrency
            )
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}


private extension CurrencyView {
    var convertButton: some View {
        Button {
            viewModel.convert()
            amountIsForcus = false
        } label: {
            Text("Convert")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: viewModel.canConvert
                        ? [AppColors.primary, AppColors.secondary]
                        : [Color.gray.opacity(0.4), Color.gray.opacity(0.4)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(14)
        }
        .disabled(!viewModel.canConvert)
        .animation(.easeInOut, value: viewModel.canConvert)
    }
}


private extension CurrencyView {
    func resultCard(result: String) -> some View {
        VStack(spacing: 8) {
            Text("Convert Amount")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(result)
                .font(.largeTitle.bold())
                .foregroundColor(AppColors.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}
