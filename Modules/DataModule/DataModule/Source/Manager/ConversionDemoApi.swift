//
//  ConversionDemoApi.swift
//  Demo
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation
import RxSwift

fileprivate extension CurrencyConversionResult {
    
    func asObservable() -> Observable<CurrencyConversionResult> {
        return Observable.just(self)
    }
    
}

struct ConversionDemoApi {
    
    static let commissionFeeRate = 0.007
    
    static let balanceList = CurrencyBalanceList(items: [CurrencyBalance(code: "EUR", name: "EUR", balance: 1000),
                                                         CurrencyBalance(code: "JPY", name: "JPY", balance: 0),
                                                         CurrencyBalance(code: "USD", name: "USD", balance: 0)])
    
    private static var supportedCurrencies: [CurrencyBalance] { get { return balanceList.items }}
    
    static func convertAmount(_ amount: Double,
                              from origin: String,
                              to destination: String) -> Observable<CurrencyConversionResult> {
        
        guard let originCurrency = supportedCurrencies.first(where: { $0.code == origin} ),
            let destCurrency = supportedCurrencies.first(where: { $0.code == destination }),
            origin != destination else {
                return CurrencyConversionResult(fromAmount: amount,
                                                fromCurrency: origin,
                                                toAmount: 0,
                                                toCurrency: destination,
                                                commissionFee: 0,
                                                isSuccess:  false).asObservable()
        }
        
        let commissionFee = amount * commissionFeeRate
        let transactionAmount = amount + commissionFee
        guard transactionAmount <= originCurrency.balance else {
            return CurrencyConversionResult(fromAmount: amount,
                                            fromCurrency: origin,
                                            toAmount: 0,
                                            toCurrency: destination,
                                            commissionFee: 0,
                                            isSuccess:  false).asObservable()
        }
        
        let credited: Observable<CurrencyPreviewResult?> = DataManager
            .fetch(resource: Resource.currencyPreview(fromAmount: amount,
                                                      fromCurrency: origin,
                                                      toCurrency: destination))

        
        
        return credited
            .map { (result) -> CurrencyConversionResult in
                
                guard let converted = result?.amount, amount > 0 else {
                    return CurrencyConversionResult(fromAmount: amount,
                                                    fromCurrency: origin,
                                                    toAmount: 0,
                                                    toCurrency: destination,
                                                    commissionFee: 0,
                                                    isSuccess:  false)
                }
                
                destCurrency.balance += converted
                originCurrency.balance -= transactionAmount
                return CurrencyConversionResult(fromAmount: amount,
                                                fromCurrency: origin,
                                                toAmount: converted,
                                                toCurrency: destination,
                                                commissionFee: commissionFee,
                                                isSuccess:  true)
                
            }
    }
    
}
