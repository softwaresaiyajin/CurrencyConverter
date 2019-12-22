//
//  Navigator.swift
//  NavigatorModule
//
//  Created by Gerald Adorza on 29/4/2018.
//  Copyright © 2018 Gerald Adorza. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

public protocol IViewController {
    static func nvm_create() -> UIViewController?
}

public class Navigator {
    
    public typealias NavigationObserver = (UIViewController?, Any?) -> Void
    
    public static let shared = Navigator()
    
    public let event = Variable<Event?>(nil)
    
    private var locationInstances = [String: UIViewController]()
    
    private var locationClasses = [String: IViewController.Type]()
    
    private init() {}
    
    public var registeredPaths: [String] {
        var options: [String] = []
        options.append(contentsOf: locationClasses.map( { "\($0.key) => \($0.value).self" }) )
        options.append(contentsOf: locationInstances.map( { "\($0.key) => \($0.value)" }) )
        return options
    }

    @discardableResult
    public func register(paths: String..., to location: UIViewController) -> Self {
        paths.forEach { (id) in
            locationInstances[id] = location
        }
        return self
    }
    
    @discardableResult
    public func register(paths: String..., to location: IViewController.Type) -> Self {
        paths.forEach { (id) in
            locationClasses[id] = location
        }
        return self
    }
    
    public func navigate(to path: String, data input: Any?) {
        if let match = locationInstances[path] {
            event.value = Event(controller: match, data: input, path:path)
        }
        else if let match = locationClasses[path] {
            event.value = Event(controller: match.nvm_create(), data: input, path:path)
        }
        else {
            event.value = Event(controller: nil, data: nil, path: path)
        }
    }
}
