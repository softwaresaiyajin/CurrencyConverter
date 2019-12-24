//
//  Section.swift
//  HomeModule
//
//  Created by Gerald on 21/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation
import RxSwift

enum CellType {
    
    case balances([CurrencyBalanceProtocol])
    
    case transactionStep(TransactionType)
    
}

class TransactionType {
    
    let name: String
    let icon: String
    let isOutput: Bool
   
    let currency = Variable<CurrencyBalanceProtocol?>(nil)

    let displayAmount = Variable<Double>(0)

    init(name: String, icon: String, isOutput: Bool) {
        self.name = name
        self.icon = icon
        self.isOutput = isOutput
    }
    
}

