//
//  ModuleConstants.swift
//  HomeModule
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

struct ModuleConstants {
    
    static let cancelButtonTitle = "Close"
    
    static let storyBoard = UIStoryboard(name: "Main",
                                         bundle: ModuleConstants.bundle)
    
    static let bundle = Bundle(for: HomeViewController.self)
    
}
