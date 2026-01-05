//
//  CurrencyView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-08.
//

import SwiftUI

struct CurrencyView: View {
    
    @StateObject private var viewModel = CurrencyViewModel()
    @FocusState private var isAmountFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    
                    // Input Section
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Amount")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 4)
                        
                        AppCard {
                            HStack {
                                Text(viewModel.fromCurrency.rawValue)
                                    .font(.title2.bold())
                                    .foregroundColor(.secondary)
                                
                                TextField("0.00", text: $viewModel.amount)
                                    .focused($isAmountFocused)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 32, weight: .bold))
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                        }
                    }
                    
                    // Currency Selection
                    ZStack {
                        VStack(spacing: AppSpacing.md) {
                            CurrencyPickerRow(title: "From", selection: $viewModel.fromCurrency)
                            CurrencyPickerRow(title: "To", selection: $viewModel.toCurrency)
                        }
                        
                        // Swap Button Overlay
                        Button {
                            withAnimation(.spring()) {
                                viewModel.swapCurrencies()
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(AppColors.primary)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                                .overlay(
                                    Circle()
                                        .stroke(Color(uiColor: .systemBackground), lineWidth: 4)
                                )
                        }
                    }
                    
                    // Result Section
                    if viewModel.isLoading {
                        AppCard {
                            VStack(spacing: 8) {
                                SkeletonView()
                                    .frame(height: 16)
                                    .frame(width: 100)
                                SkeletonView()
                                    .frame(height: 40)
                                    .frame(width: 200)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    } else if let result = viewModel.convertedAmount {
                        AppCard {
                            VStack(spacing: 8) {
                                Text("\(viewModel.toCurrency.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(result)
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(AppColors.primary)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.sm)
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else if let error = viewModel.errorMessage {
                        ErrorStateView(errorMessage: error, retryAction: {})
                    }
                    
                    Spacer()
                }
                .padding(AppSpacing.md)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
            .onTapGesture {
                isAmountFocused = false
            }
            .navigationTitle("Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isAmountFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    CurrencyView()
}
