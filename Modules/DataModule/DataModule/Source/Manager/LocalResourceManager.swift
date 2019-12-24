//
//  LocalResourceManager.swift
//  DataModule
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation
import RxSwift

class LocalResourceManager {
    
    static func fetch<T: Codable>(resource: Resource,
                                  parameters: [String: Any]? = nil) -> Observable<T?> {
        
        switch resource {
            
        case .currencyBalances:
            return Observable.just(ConversionDemoApi.balanceList as? T)
            
        case .currencyConversion(let amount, let from, let to):
            return ConversionDemoApi
                .convertAmount(amount, from: from, to: to)
                .map( { $0 as? T })
            
        default:
            return Observable.just(nil)
        }
        
        
    }
    
}
