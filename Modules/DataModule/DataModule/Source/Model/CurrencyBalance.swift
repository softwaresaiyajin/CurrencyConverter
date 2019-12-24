//
//  CurrencyBalance.swift
//  DataModule
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

public class CurrencyBalance: Codable  {
    
    private enum Identifier: String, CodingKey {
        case balance
        case name
        case code
    }
    
    public let code: String
    
    public let name: String
    
    public var balance: Double
    
    init(code: String, name: String, balance: Double) {
        self.code = code
        self.name = name
        self.balance = balance
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier.self)
        balance = try Double(container.decode(Double.self, forKey: .balance))
        name = try container.decode(String.self, forKey: .name)
        code = try container.decode(String.self, forKey: .code)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier.self)
        try container.encodeIfPresent(balance, forKey: .balance)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(code, forKey: .code)
    }
}

