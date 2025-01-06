//
//  File.swift
//  
//
//  Created by vijay pokuri on 06/01/25.
//

import Foundation

struct ExchangeRates: Codable {
    let rates: [String: Double]
}

struct ExchangeRecord: Identifiable {
    let id = UUID()
    let time: Date
    let sourceCurrency: String
    let targetCurrency: String
    let sourceAmount: Double
    let targetAmount: Double
}

enum Currency: String, CaseIterable {
    case EUR
    case JPY
    case GBP
    case INR
}
