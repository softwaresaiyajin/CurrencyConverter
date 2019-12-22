//
//  ConversionDemoApi.swift
//  Demo
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation
import RxSwift

/*
    All processes contained in this class should be
    performed remotely. The purpose of this class to
    just mock the functionality
 */

fileprivate extension CurrencyConversionResult {
    
    func asObservable() -> Observable<CurrencyConversionResult> {
        return Observable.just(self)
    }
}

struct ConversionDemoApi {
    
    fileprivate struct Constant {
        
        static let commissionFeeRate = 0.007
        
        static let freeTransactionThreshold = 5
    }
    
    
    private static var storage: ConversionDemoStorage = {
        return ConversionDemoStorage()
    }()

    static let balanceList = CurrencyBalanceList(items: storage.getCurrencyBalances())
    
    static func convertAmount(_ amount: Double,
                              from origin: String,
                              to destination: String) -> Observable<CurrencyConversionResult> {
        
        debugPrint("Converting: \(amount) | \(origin) | \(destination)")
        
        let supportedCurrencies = balanceList.items
        
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
        
        let commissionRate = storage.getTransactionCount() < Constant.freeTransactionThreshold
            ? 0.0
            : Constant.commissionFeeRate
        let commissionFee = amount * commissionRate
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
            .map({ (result) -> CurrencyConversionResult in
                
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
                storage.saveCurrencyBalances(supportedCurrencies)
                storage.recordSuccessfulTransaction()
            
                return CurrencyConversionResult(fromAmount: amount,
                                                fromCurrency: origin,
                                                toAmount: converted,
                                                toCurrency: destination,
                                                commissionFee: commissionFee,
                                                isSuccess:  true)
                
            }).share(replay: 1, scope: .whileConnected)
    }
    
}
