//
//  DataProviderProtocol.swift
//  HomeModule
//
//  Created by Gerald on 21/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation
import RxSwift

public protocol DataProviderProtocol: class {
    
    func hm_getCurrencyBalances() -> Observable<[CurrencyBalanceProtocol]>
    
    func hm_getConvertedAmountPreview(_ amount: Double,
                                      from originCurrency: String,
                                      to destinationCurrency: String) -> Observable<Double>
    
    func hm_submitRequest(amount: Double,
                          from originCurrency: String,
                          to destinationCurrency: String) -> Observable<ConversionResultProtocol?>
}
