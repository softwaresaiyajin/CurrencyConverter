//
//  CurrencyConversionResult.swift
//  DataModule
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

public struct CurrencyPreviewResult {
    
    public let amount: Double
    
    public let currency: String
    
}

// MARK: -
// MARK: Codable
extension CurrencyPreviewResult: Codable {
    
    private enum Identifier: String, CodingKey {
        case amount
        case currency
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier.self)
        amount = try Double(container.decode(String.self, forKey: .amount)) ?? 0
        currency = try container.decode(String.self, forKey: .currency)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier.self)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(currency, forKey: .currency)
    }
}
