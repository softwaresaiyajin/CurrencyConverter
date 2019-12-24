//
//  Endpoint.swift
//  DataModule
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation
import Alamofire

public enum Resource {
    
    case currencyPreview(fromAmount: Double,
        fromCurrency: String,
        toCurrency: String)
    
    case currencyConversion(fromAmount: Double,
        fromCurrency: String,
        toCurrency: String)
    
    case currencyBalances
    
}

extension Resource {
    
    var isRemote: Bool {
        switch self {
        case .currencyPreview: return true
        default: return false
        }
    }
    
    var dynamicUrl: String {
        
        switch self {
        case .currencyPreview(let fromAmount, let fromCurrency, let toCurrency):
            return "/currency/commercial/exchange/\(fromAmount)-\(fromCurrency)/\(toCurrency)/latest"
        default: return""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .currencyPreview: return .get
        default: return .get
        }
    }
    
    var fullUrl: String {
        let root = "http://api.evp.lt"
        return "\(root)\(dynamicUrl)"
    }
    
}
