//
//  CurrencyConversionResult.swift
//  DataModule
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

public class CurrencyConversionResult: Codable {
    
    fileprivate enum Identifier: String, CodingKey {
        case fromAmount
        case toAmount
        case fromCurrency
        case toCurrency
        case isSuccess
        case commissionFee
    }
    
    public let fromAmount: Double
    
    public let toAmount: Double
    
    public let fromCurrency: String
    
    public let toCurrency: String
    
    public let isSuccess: Bool
    
    public let commissionFee: Double
    
    init(fromAmount: Double,
         fromCurrency: String,
         toAmount: Double,
         toCurrency: String,
         commissionFee: Double,
         isSuccess: Bool) {
        self.fromAmount = fromAmount
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.isSuccess = isSuccess
        self.toAmount = toAmount
        self.commissionFee = commissionFee
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier.self)
        fromAmount = try Double(container.decode(String.self, forKey: .fromAmount)) ?? 0
        toAmount = try Double(container.decode(String.self, forKey: .toAmount)) ?? 0
        fromCurrency = try container.decode(String.self, forKey: .fromCurrency)
        toCurrency = try container.decode(String.self, forKey: .toCurrency)
        commissionFee = try Double(container.decode(String.self, forKey: .commissionFee)) ?? 0
        isSuccess = try container.decode(Bool.self, forKey: .isSuccess)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier.self)
        try container.encodeIfPresent(fromAmount, forKey: .fromAmount)
        try container.encodeIfPresent(fromCurrency, forKey: .fromCurrency)
        try container.encodeIfPresent(toCurrency, forKey: .toCurrency)
        try container.encodeIfPresent(isSuccess, forKey: .isSuccess)
        try container.encodeIfPresent(toAmount, forKey: .toAmount)
        try container.encodeIfPresent(commissionFee, forKey: .commissionFee)
    }
    
}
