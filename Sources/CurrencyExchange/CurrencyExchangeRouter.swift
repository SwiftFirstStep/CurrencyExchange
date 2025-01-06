//
//  File.swift
//  
//
//  Created by vijay pokuri on 06/01/25.
//

import Foundation

@available(macOS 11.0, *)
struct CurrencyExchangeRouter {
    static func build() -> CurrencyExchangeView {
        let interactor = CurrencyExchangeInteractor()
        let presenter = CurrencyExchangePresenter(interactor: interactor)
        return CurrencyExchangeView(presenter: presenter)
    }
}
