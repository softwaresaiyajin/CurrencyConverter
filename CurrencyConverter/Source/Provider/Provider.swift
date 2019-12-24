//
//  Provider.swift
//  CurrencyConverter
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

class Provider {
    
    static let shared = Provider()
    
    let appearance = Appearance()
    
    private init() {}
}
