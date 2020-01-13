//
//  DefaultRule.swift
//  DataModule
//
//  Created by Gerald on 24/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

class DefaultRule {
    
    private struct Constant {
        
        static let commissionFeeRate = 0.007
        
        static let freeTransactionThreshold = 5
    }
    
    var canExecuteTransaction: Bool { return transactionAmount <= originCurrency.balance }
    
    var transactionAmount: Double { return commissionFee + amount }
    
    var commissionFee: Double
    
    let originCurrency: CurrencyBalance
    
    let targetCurrency: CurrencyBalance
    
    let amount: Double
    
    init(storage: ConversionDemoStorage,
         originCurrency: CurrencyBalance,
         targetCurrency: CurrencyBalance,
         amount: Double) {
        
        self.originCurrency = originCurrency
        self.targetCurrency = targetCurrency
        self.amount = amount
        
        let isFree = storage.getTransactionCount() < Constant.freeTransactionThreshold
        commissionFee = isFree ? 0 : amount * Constant.commissionFeeRate
    }
}
