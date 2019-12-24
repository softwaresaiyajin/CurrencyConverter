//
//  ConversionResultProtocol.swift
//  HomeModule
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

public protocol ConversionResultProtocol {
    
    var hm_isSuccess: Bool { get }
    
    var hm_message: String? { get }
    
}
