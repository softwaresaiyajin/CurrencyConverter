//
//  ConversionDemoApi.swift
//  Demo
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation
import HomeModule

class CurrencyBalance {
    
    var balance: Double
    
    var currencyName: String
    
    var currencyCode: String
    
    init(code: String, name: String, balance: Double) {
        self.balance = balance
        self.currencyName = name
        self.currencyCode = code
    }
}

extension CurrencyBalance: CurrencyBalanceProtocol {
    
    var hm_balance: Double { return balance }
    
    var hm_currencyName: String? { return currencyName }
    
    var hm_currencyCode: String? { return currencyCode }
    
    var hm_formattedBalance: String? {
        return "\(balance.appCurrencyFormat) \(currencyCode)"
    }
}

enum ConversionResult {
    case success(fromAmount: String, toAmount: String, commission: String)
    case failed
}

extension ConversionResult: ConversionResultProtocol {
    
    var hm_isSuccess: Bool {
        switch self {
        case .success: return true
        default: return false
        }
    }
    
    var hm_message: String? {
        switch self {
        case .success(let fromAmount, let toAmount, let commission):
            return "You have converted \(fromAmount) to \(toAmount). Commission fee - \(commission)."
            
        default:
            return "Insufficient balance"
        }
    }
}

extension Double {
    
    var appCurrencyFormat: String {
        return String.init(format: "%.2f", self)
    }
    
}

struct ConversionDemoApi {
    
    static let commissionFeeRate = 0.007
    
    static let supportedCurrencies = [CurrencyBalance(code: "EUR", name: "EUR", balance: 1000),
                                      CurrencyBalance(code: "JPY", name: "JPY", balance: 0),
                                      CurrencyBalance(code: "USD", name: "USD", balance: 0)]
    

    static func getConvertedAmountPreview(_ fromAmount: Double,
                              from origin: String,
                              to destination: String) -> Double {
        
        guard let index = supportedCurrencies.firstIndex(where: { $0.currencyCode == destination}) else {
            return 0;
        }
        let conversionRate = (10 - (Double(index) + 1))/10
        
        
        return fromAmount * conversionRate
        
    }
    
    static func convertAmount(_ amount: Double,
                              from origin: String,
                              to destination: String) -> ConversionResult {
        
        guard let originCurrency = supportedCurrencies.first(where: { $0.currencyCode == origin} ),
            let destCurrency = supportedCurrencies.first(where: { $0.currencyCode == destination }),
            origin != destination else { return ConversionResult.failed }
        
        let commissionFee = amount * commissionFeeRate
        let transactionAmount = amount + commissionFee
        guard transactionAmount <= originCurrency.balance else {
            return ConversionResult.failed;
        }
        
        originCurrency.balance -= transactionAmount
        let credited = getConvertedAmountPreview(amount, from: origin, to: destination)
        destCurrency.balance += credited
        
        return ConversionResult.success(fromAmount: "\(amount.appCurrencyFormat) \(origin)",
            toAmount: "\(credited.appCurrencyFormat) \(destination)",
            commission: "\(commissionFee.appCurrencyFormat) \(origin)")
    }
    
}
