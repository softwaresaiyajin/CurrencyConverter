//
//  Request.swift
//  DataModule
//
//  Created by Gerald Adorza on 29/4/2018.
//  Copyright © 2018 Gerald Adorza. All rights reserved.
//

import Foundation
import Alamofire

class ClientRequest {
    
    static func create(resource: Resource,
                       parameters: [String: Any]?) -> URLRequest? {
        if resource.method == .get {
            guard var components = URLComponents(string: resource.fullUrl) else { return nil }
            components.queryItems = parameters?
                .compactMap( { URLQueryItem(name: $0.key, value: "\($0.value)")} )
            guard let url = components.url else  { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = resource.method.rawValue
            return request
        }
        
        else {
            guard let url = URL(string: resource.fullUrl) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = resource.method.rawValue
            if let body = try? JSONSerialization.data(withJSONObject: parameters ?? [:],
                                                      options: .prettyPrinted) {
                request.httpBody = body
            }
            return request
        }
    }
}
