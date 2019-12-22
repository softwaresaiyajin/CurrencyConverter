//
//  MainController.swift
//  CurrencyConverter
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation
import UIKit
import HomeModule

class MainController {
    
    static let instance = MainController()
    
    private var window: UIWindow?
    
    private init() {}
    
    func launch(in window: UIWindow, provider: Provider?) {
        
        self.window = window;
        //self.provider = provider;
        
        let controller = HomeViewController.create(dataProvider: provider,
                                                   routeProvider: nil)
        let navcon = UINavigationController(rootViewController: controller)
        window.rootViewController = navcon
    }
    
    
}
