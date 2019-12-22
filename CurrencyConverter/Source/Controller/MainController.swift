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
import NavigatorModule
import RxSwift

enum Location: String {
    case root = "/root"
    case back = "/"
}

class MainController {
    
    static let instance = MainController()
    
    private var window: UIWindow?
    
    private lazy var bag: DisposeBag = {
        return DisposeBag()
    }()
    
    private init() {}
    
    func launch(in window: UIWindow) {
        
        self.window = window;
        setupLocations()
        setupLocationObservers()
        setupRoot()
    }
    
    private func setupLocations() {
        
        Navigator.shared
            .register(paths: Location.root.rawValue,to: HomeViewController.self)
        
    }
    
    private func setupLocationObservers() {
        
        Navigator.shared.event.asObservable()
            .subscribe(onNext : { [weak self] event in
                
                if let controller = event?.controller as? HomeViewController {
                    self?.window?.rootViewController = UINavigationController(rootViewController: controller)
                }
            })
            .disposed(by: bag)
    }
    
    private func setupRoot() {
        Navigator.shared
            .navigate(to: Location.root.rawValue, data: nil)
    }
}
