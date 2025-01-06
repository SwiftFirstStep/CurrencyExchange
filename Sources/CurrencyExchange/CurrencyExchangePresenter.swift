//
//  File.swift
//  
//
//  Created by vijay pokuri on 06/01/25.
//

import Foundation
import SwiftUI
import Combine

@available(macOS 11.0, *)
protocol CurrencyExchangePresenterProtocol: ObservableObject {
    func fetchCurrentExchangeRate()
}

@available(macOS 11.0, *)
class CurrencyExchangePresenter: CurrencyExchangePresenterProtocol {
    
    private let interactor: CurrencyExchangeInteractorProtocol
    private var cancellables = Set<
        AnyCancellable>()
    @ObservedObject var sharedData = SharedAccountData.shared //env
    //seperate packages
    
    @Published var currentRate: Double = 0.0
    @Published var selectedCurrency: Currency = .INR
    @Published var amountToExchange: Double = 0.0
    @Published var convertedAmount: Double = 0.0
    @Published var exchangeHistory: [ExchangeRecord] = []
    
    let availableCurrencies = ["EUR", "JPY", "GBP", "INR"] //enum
    
    var accountBalance: Double {
        get { sharedData.accountBalance }
        set { sharedData.accountBalance = newValue }
    }
    
    init(interactor: CurrencyExchangeInteractorProtocol) {
        self.interactor = interactor
        fetchCurrentExchangeRate()
        bindAmountToExchange()
    }
    
    private func bindAmountToExchange() {
        $amountToExchange
            .combineLatest($currentRate)
            .map { amount, rate in amount * rate }
            .assign(to: &$convertedAmount)
    }
    
    func fetchCurrentExchangeRate() {
        interactor.fetchCurrentExchangeRate(for: selectedCurrency.rawValue)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching exchange rates: \(error)")
                }
            }, receiveValue: { [weak self] exchangeRate in
                self?.currentRate = exchangeRate
            })
            .store(in: &cancellables)
    }
    
    func exchangeNow() {
        guard amountToExchange > 0 else { return }
        
        accountBalance -= amountToExchange
        addExchangeHistoryRecord()
        resetValues()
    }
    
    private func resetValues() {
        amountToExchange = 0.0
    }
    
    private func addExchangeHistoryRecord() {
        let record = ExchangeRecord(
            time: Date(),
            sourceCurrency: "USD",
            targetCurrency: selectedCurrency.rawValue,
            sourceAmount: amountToExchange,
            targetAmount: convertedAmount
        )
        exchangeHistory.insert(record, at: 0)
    }
}
