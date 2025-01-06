//
//  File.swift
//  
//
//  Created by vijay pokuri on 06/01/25.
//

import Foundation
import Combine

@available(macOS 10.15, *)
protocol CurrencyExchangeInteractorProtocol {
    func fetchCurrentExchangeRate(for currency: String) -> AnyPublisher<Double, Error>
}
@available(macOS 10.15, *)
class CurrencyExchangeInteractor: CurrencyExchangeInteractorProtocol {

    var cancellables = Set<AnyCancellable>()
    
    func fetchCurrentExchangeRate(for currency: String) -> AnyPublisher<Double, Error> {
        let url = URL(string: "https://api.exchangerate-api.com/v4/latest/USD")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ExchangeRates.self, decoder: JSONDecoder())
            .map { $0.rates[currency] ?? 1.0 }
            .eraseToAnyPublisher()
    }
}
