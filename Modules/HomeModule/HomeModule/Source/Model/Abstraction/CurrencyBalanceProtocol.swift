//
//  CurrencyProtocol.swift
//  HomeModule
//
//  Created by Gerald on 21/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

public protocol CurrencyBalanceProtocol {
    
    var hm_balance: Double { get }
    
    var hm_currencyName: String? { get }
    
    var hm_currencyCode: String? { get }
    
    var hm_formattedBalance: String? { get }
}


