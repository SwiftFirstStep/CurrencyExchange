//
//  File.swift
//  
//
//  Created by vijay pokuri on 06/01/25.
//

import SwiftUI

@available(macOS 10.15, *)
struct CurrencyExchangeView: View {
    
    @ObservedObject var presenter: CurrencyExchangePresenter
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Account Balance Section
                HStack {
                    Text("Your Account Balance:")
                        .font(.headline)
                    Spacer()
                    Text("$\(presenter.sharedData.accountBalance, specifier: "%.2f")")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                } //HStack End
                
                // Target Currency Selection
                HStack {
                    Text("Select the Target Currency:")
                    Spacer()
                    Picker("Target Currency", selection: $presenter.selectedCurrency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.rawValue).tag(currency)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: presenter.selectedCurrency) { _ in
                        presenter.fetchCurrentExchangeRate()
                    }
                }
                
                // Amount to Exchange Section
                HStack {
                    Text("Select the amount to Exchange:")
                        .font(.headline)
                        .padding(.top, 20)
                    Spacer()
                    Text("\(presenter.amountToExchange, specifier: "%.2f") $")
                        .font(.headline)
                        .padding(.top, 20)
                }
                Slider(
                    value: $presenter.amountToExchange,
                    in: 0...max(1, presenter.accountBalance),
                    step: 1
                )
                .disabled(presenter.accountBalance <= 0)
                .accentColor(.blue)
                .padding()
                
                HStack {
                    Text("Converted Amount:")
                        .font(.headline)
                        .padding(.top, 20)
                    Spacer()
                    Text("\(presenter.convertedAmount, specifier: "%.2f") \(presenter.selectedCurrency.rawValue)")//
                        .font(.headline)
                        .padding(.top, 20)
                }
                
                HStack {
                    Spacer()
                    Text("(Current USD Rate: 1 USD = \(presenter.currentRate, specifier: "%.2f") \(presenter.selectedCurrency.rawValue))")//new type
                        .font(.subheadline)
                    Spacer()
                }
                
                // Exchange Now Button
                Button(action: presenter.exchangeNow) {
                    Text("Exchange Now")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(presenter.amountToExchange == 0 ? .gray : .blue)//
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(presenter.amountToExchange == 0) // Disable the button if amount is 0 //
                
                // Exchange History Section
                if !presenter.exchangeHistory.isEmpty {
                    Text("Exchange History")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Table Headings
                        HStack {
                            Text("Time")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Source")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Target")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }//subclass or group // module
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                        
                        Divider()
                        
                        // Table Rows
                        ForEach(presenter.exchangeHistory) { record in
                            HStack {
                                Text("\(record.time, formatter: DateFormatter.custom)")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(record.sourceCurrency) \(record.sourceAmount, specifier: "%.2f")")//
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(record.targetCurrency) \(record.targetAmount, specifier: "%.2f")") //
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }// Exchange History Section End
                Spacer()
            } // Vstack End
            .padding()
            .navigationTitle("Exchange")
            .navigationBarTitleDisplayMode(.inline) // Small title
        } // ScrollView End
    }
}

//struct CurrencyExchangeView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyExchangeView( presenter: .init(interactor: .init()))
//    }
//}
