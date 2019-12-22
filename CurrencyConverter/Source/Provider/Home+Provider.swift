//
//  Home+Provider.swift
//  CurrencyConverter
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation
import HomeModule
import RxSwift
import DataModule
import NavigatorModule

extension HomeViewController: IViewController {
    
    public static func nvm_create() -> UIViewController? {
        return HomeViewController.create(dataProvider: Provider.shared,
                                         routeProvider: Provider.shared)
    }
}

extension CurrencyBalance: CurrencyBalanceProtocol {
    
    public var hm_balance: Double { return balance }
    
    public var hm_currencyName: String? { return name }
    
    public var hm_currencyCode: String? { return code }
    
    public var hm_formattedBalance: String? { return balance.appCompatibleFormat(code: name)  }

}

extension CurrencyConversionResult: ConversionResultProtocol {
    
    public var hm_isSuccess: Bool { return isSuccess }
    
    public var hm_message: String? {
        
        return isSuccess
        ?  "You have converted \(fromAmount.appCompatibleFormat(code: fromCurrency)) to \(toAmount.appCompatibleFormat(code: toCurrency)). Commission fee - \(commissionFee.appCompatibleFormat(code: fromCurrency))."
        : "Insufficient funds"
    }
}

extension Provider: DataProviderProtocol {
    
    func hm_getCurrencyBalances() -> Observable<[CurrencyBalanceProtocol]> {
        
        let result: Observable<CurrencyBalanceList?> = DataManager.fetch(resource: .currencyBalances)
        return result
            .map({ (list) -> [CurrencyBalanceProtocol] in
                return list?.items.compactMap( { $0 } ) ?? []
            })
    }
    
    func hm_getConvertedAmountPreview(_ amount: Double,
                                      from originCurrency: String,
                                      to destinationCurrency: String) -> Observable<Double> {
        
        let result: Observable<CurrencyPreviewResult?> = DataManager
            .fetch(resource: .currencyPreview(fromAmount: amount,
                                              fromCurrency: originCurrency,
                                              toCurrency: destinationCurrency))
        
        return result.map( { $0?.amount ?? 0 })
    }
    
    func hm_submitRequest(amount: Double,
                          from originCurrency: String,
                          to destinationCurrency: String) -> Observable<ConversionResultProtocol?> {
        
        let result: Observable<CurrencyConversionResult?> = DataManager
            .fetch(resource: .currencyConversion(fromAmount: amount,
                                                 fromCurrency: originCurrency,
                                                 toCurrency: destinationCurrency))
        
        return result.map( { $0 })
    }
}

extension Provider: RouteProviderProtocol {
    
    func hm_navigate(to path: Route, data parameters: Any?) {
        
    }
}
