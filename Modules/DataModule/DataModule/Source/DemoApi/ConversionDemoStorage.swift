//
//  ConversionDemoStorage.swift
//  DataModule
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

/*
    All processes contained in this class should be
    performed remotely. The purpose of this class to
    just mock the functionality
 */
class ConversionDemoStorage {
    
    private struct Constant {
    
        struct Key {
            static let currencies = "currencies"
            static let transactionCount = "transactionCount"
        }
    }
    
    /*
        For demo purposes and not to invest time in ORM,
        we'll be using standard defaults, but this should
        be stored, ideally, in a more structured storage
     */
    private let context = UserDefaults.standard
    
    func getCurrencyBalances() -> [CurrencyBalance] {
        
        if let savedCurrencies = context.stringArray(forKey: Constant.Key.currencies) {
            
            return savedCurrencies
                .map({ (code) -> CurrencyBalance in
                    let balance = context.double(forKey: code)
                    return CurrencyBalance(code: code, name: code, balance: balance)
                })
        }
        
        return [CurrencyBalance(code: "EUR", name: "EUR", balance: 1000),
                CurrencyBalance(code: "JPY", name: "JPY", balance: 0),
                CurrencyBalance(code: "USD", name: "USD", balance: 0)]
    }
    
    func saveCurrencyBalances(_ balances: [CurrencyBalance]) {
        
        let keys = balances.map( { $0.code} )
        context.set(keys, forKey: Constant.Key.currencies)
        balances.forEach { (balance) in
            context.set(balance.balance, forKey: balance.code)
        }
        context.synchronize()
    }
    
    func recordSuccessfulTransaction() {
        
        let count = getTransactionCount()
        context.set(count + 1, forKey: Constant.Key.transactionCount)
        context.synchronize()
    }
    
    func getTransactionCount() -> Int {
        return context.integer(forKey: Constant.Key.transactionCount)
    }
}
