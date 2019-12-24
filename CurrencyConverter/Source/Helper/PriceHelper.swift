//
//  PriceHelper.swift
//  CurrencyConverter
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

extension Double {
    
    func appCompatibleFormat(code: String? = nil) -> String {
        
        guard let suffix = code else {
            return String.init(format: "%.2f", self)
        }
        return String.init(format: "%.2f \(suffix)", self)
        
    }
    

}
