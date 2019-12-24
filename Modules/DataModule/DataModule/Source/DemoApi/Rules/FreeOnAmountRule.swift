//
//  FreeOnAmountRule.swift
//  DataModule
//
//  Created by Gerald on 24/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

class FreeOnAmountRule: DefaultRule {
    
    struct Constant {
        static let threshold = 200.0
        static let freeCurrencyCode = "eur"
    }
    
    override init(storage: ConversionDemoStorage,
                  originCurrency: CurrencyBalance,
                  targetCurrency: CurrencyBalance,
                  amount: Double) {
        
        super.init(storage: storage,
                   originCurrency: originCurrency,
                   targetCurrency: targetCurrency,
                   amount: amount)
        
        guard originCurrency.code.lowercased() == Constant.freeCurrencyCode,
            amount <= Constant.threshold else { return }
        commissionFee = 0
    }
}
