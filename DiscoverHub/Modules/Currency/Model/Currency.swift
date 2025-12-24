//
//  Currency.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-25.
//

import Foundation

enum Currency: String, CaseIterable, Identifiable {
    case AUD, BGN, BRL, CAD, CHF, CNY, CZK, DKK, EUR, GBP, HKD, HUF, IDR, ILS, INR, ISK, JPY, KRW, MXN, MYR, NOK, NZD, PHP, PLN, RON, SEK, SGD, THB, TRY, USD, ZAR
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .AUD: return "Australian Dollar"
        case .BGN: return "Bulgarian Lev"
        case .BRL: return "Brazilian Real"
        case .CAD: return "Canadian Dollar"
        case .CHF: return "Swiss Franc"
        case .CNY: return "Chinese Renminbi Yuan"
        case .CZK: return "Czech Koruna"
        case .DKK: return "Danish Krone"
        case .EUR: return "Euro"
        case .GBP: return "British Pound"
        case .HKD: return "Hong Kong Dollar"
        case .HUF: return "Hungarian Forint"
        case .IDR: return "Indonesian Rupiah"
        case .ILS: return "Israeli New Shekel"
        case .INR: return "Indian Rupee"
        case .ISK: return "Icelandic Króna"
        case .JPY: return "Japanese Yen"
        case .KRW: return "South Korean Won"
        case .MXN: return "Mexican Peso"
        case .MYR: return "Malaysian Ringgit"
        case .NOK: return "Norwegian Krone"
        case .NZD: return "New Zealand Dollar"
        case .PHP: return "Philippine Peso"
        case .PLN: return "Polish Złoty"
        case .RON: return "Romanian Leu"
        case .SEK: return "Swedish Krona"
        case .SGD: return "Singapore Dollar"
        case .THB: return "Thai Baht"
        case .TRY: return "Turkish Lira"
        case .USD: return "United States Dollar"
        case .ZAR: return "South African Rand"
        }
    }
}
