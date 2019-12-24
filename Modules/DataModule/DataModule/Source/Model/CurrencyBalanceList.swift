//
//  CurrencyBalanceList.swift
//  DataModule
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

public class CurrencyBalanceList: Codable  {
    
    private enum Identifier: String, CodingKey {
        case items
    }
    
    public let items: [CurrencyBalance]
    
    init(items: [CurrencyBalance]) {
        self.items = items
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier.self)
        items = try container.decode([CurrencyBalance].self, forKey: .items)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier.self)
        try container.encodeIfPresent(items, forKey: .items)
    }
    
}
