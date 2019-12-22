//
//  ViewModel.swift
//  HomeModule
//
//  Created by Gerald on 21/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation
import RxSwift
import Differentiator

typealias SectionData = SectionModel<String, CellType>

class ViewModel {
    
    private struct Constants {
        
        static let maxSupportedCurrencies: Int = 3
        
        static let myBalances = "MY BALANCES"
        
        static let currencyExchange = "CURRENCY EXCHANGE"
        
    }
    
    private(set) weak var dataProvider: DataProviderProtocol?
    
    private(set) weak var routeProvider: RouteProviderProtocol?
    
    private(set) weak var disposeBag: DisposeBag?
    
    private(set) var availableCurrencies: [CurrencyBalanceProtocol] = []
    
    private(set) var sections = Variable<[SectionData]>([])
    
    private var mostRecentAmount = 0.0
        
    private lazy var sellTransaction = {
        return TransactionType(name: "Sell", icon: "arrowSell", isOutput: false)
    }()
    
    private lazy var receiveTransaction = {
        return TransactionType(name: "Receive", icon: "arrowReceive", isOutput: true)
    }()
    
    init(dataProvider: DataProviderProtocol?,
         routeProvider: RouteProviderProtocol?,
         disposeBag: DisposeBag) {
        
        self.dataProvider = dataProvider
        self.routeProvider = routeProvider;
        self.disposeBag = disposeBag
    }
    
    private func resetValues() {
        mostRecentAmount = 0
        receiveTransaction.displayAmount.value = 0
    }
    
    func setDefaults(currencies: [CurrencyBalanceProtocol]) {
        
        if sellTransaction.currency.value == nil {
            sellTransaction.currency.value = currencies.count > 0 ? currencies[0] : nil
        }
        
        if receiveTransaction.currency.value == nil {
            receiveTransaction.currency.value = currencies.count > 1 ? currencies[1] : nil
        }
    }
    
    func fetchData() {
        
        let currencies = dataProvider?.hm_getCurrencyBalances() ?? Observable.just([]);
        currencies
            .subscribe(onNext : { [weak self] current in
                
                self?.resetValues()
                self?.availableCurrencies = current
                self?.setDefaults(currencies: current)
                
                let transactionTypes = [self?.sellTransaction, self?.receiveTransaction]
                    .compactMap( { CellType.transactionStep($0!) })
        
                self?.sections.value = [SectionData(model: Constants.myBalances, items: [CellType.balances(current)]),
                                        SectionData(model: Constants.currencyExchange, items: transactionTypes)]
            
        }).disposed(by: disposeBag ?? DisposeBag())
    }
    
    @discardableResult
    func convertUsingMostRecentAmount() -> Observable<Double> {
        return convertAmount(mostRecentAmount)
    }

    @discardableResult
    func convertAmount(_ amount: Double) -> Observable<Double> {
        
        guard let fromCurrency = sellTransaction.currency.value?.hm_currencyCode,
            let toCurrency = receiveTransaction.currency.value?.hm_currencyCode else {
                return Observable.just(0)
        }
        
        mostRecentAmount = amount;
        
        let converted = dataProvider?
            .hm_getConvertedAmountPreview(amount, from: fromCurrency, to: toCurrency) ?? Observable.just(0)
        converted.subscribe(onNext : { [weak self] current in
            self?.receiveTransaction.displayAmount.value = current
            
        }).disposed(by: disposeBag ?? DisposeBag())
        return converted
    }
    
    func setCurrency(_ currencyCode: String?, step: TransactionType) {
        
        let currency = availableCurrencies
            .filter( { $0.hm_currencyCode == currencyCode })
            .first
        step.currency.value = currency
        convertUsingMostRecentAmount()
    }
    
    func getCurrencyOptions(for step: TransactionType) -> [CurrencyBalanceProtocol] {
        
        let exemption = step.isOutput ? sellTransaction : receiveTransaction;
        let exemptionCode = exemption.currency.value?.hm_currencyCode;
        return availableCurrencies
            .filter( { $0.hm_currencyCode != exemptionCode })
    }
    
    func goNextScreen()
    {
        routeProvider?.hm_navigate(to: .next, parameters: nil);
    }
    
    func submitConversionRequest() -> Observable<ConversionResultProtocol?> {
        
        guard let fromCurrency = sellTransaction.currency.value?.hm_currencyCode,
            let toCurrency = receiveTransaction.currency.value?.hm_currencyCode else {
                return Observable.just(nil)
        }
        
        let result = dataProvider?.hm_submitRequest(amount: mostRecentAmount,
                                                    from: fromCurrency,
                                                    to: toCurrency) ?? Observable.just(nil)
        result.subscribe(onNext : { [weak self] current in
            
            guard let success = current?.hm_isSuccess, success else { return }
            self?.fetchData()
            
        }).disposed(by: disposeBag ?? DisposeBag())

        return result
    }
    
    func getStyle() -> Observable<StyleProtocol?> {
        return dataProvider?.hm_getStyle() ?? Observable.just(nil)
    }
}
