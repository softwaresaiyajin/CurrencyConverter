//
//  FreeOnTenthRule.swift
//  DataModule
//
//  Created by Gerald on 24/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

class FreeOnTenthRule: DefaultRule {
    
    struct Constant {
        static let threshold = 10
    }
    
    override init(storage: ConversionDemoStorage,
                  originCurrency: CurrencyBalance,
                  targetCurrency: CurrencyBalance,
                  amount: Double) {
        
        super.init(storage: storage,
                   originCurrency: originCurrency,
                   targetCurrency: targetCurrency,
                   amount: amount)
        
        let transactionCount = storage.getTransactionCount()
        guard (transactionCount % Constant.threshold == 0) else { return }
        
        commissionFee = 0
    }
}
