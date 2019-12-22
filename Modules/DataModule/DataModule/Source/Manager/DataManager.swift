//
//  File.swift
//  DataModule
//
//  Created by Gerald Adorza on 24/4/2018.
//  Copyright © 2018 Gerald Adorza. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

public struct DataManager {
    
    static let bag = DisposeBag()
    
    private static let headers: [String:String] = {
        return ["Content-Type": "application/json"]
    }()
    
    public static func fetch<T: Codable>(resource: Resource,
                                         parameters: [String: Any]? = nil) -> Observable<T?> {
        
        guard resource.isRemote else {
            return LocalResourceManager.fetch(resource: resource, parameters: parameters)
        }
        
        guard var request = ClientRequest.create(resource: resource,
                                                 parameters: parameters) else {
            return Observable.just(nil)
        }
        request.allHTTPHeaderFields = headers
    
        debugPrint("request : \(request)")
        return SessionManager.default.rx
            .request(urlRequest: request)
            .responseData()
            .map { (response) -> T? in
                let decoder = JSONDecoder()
                
                do {
                    return try decoder.decode(T.self, from: response.1)
                } catch {
                    debugPrint("error : \(error)")
                }
                return nil
         }
    }
    
}
