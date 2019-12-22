//
//  RouteProviderProtocol.swift
//  HomeModule
//
//  Created by Gerald on 21/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

public enum Route: String {
    
    case next = "/hm_next"
    
}

public protocol RouteProviderProtocol: class {
    
    func hm_navigate(to path: Route, data parameters: Any?)
    
}
