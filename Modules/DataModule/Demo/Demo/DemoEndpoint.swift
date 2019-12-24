import Foundation
import RxSwift
import DataModule

extension DataManager {
    
    static let disposeBag = DisposeBag()
    
    @discardableResult
    static func fetchAndSubscribe<T: Codable>(resource: Resource,
                                              parameters: [String: Any]? = nil) -> Observable<T?> {
        
        let data: Observable<T?> = fetch(resource: resource, parameters: parameters)
        data.subscribe( onNext : { current in
            debugPrint("displayResult : \(resource) => \(String(describing: current))")
        }).disposed(by: DataManager.disposeBag)
        
        return data
    }
    
}

struct DemoEndpoint {
    
    var name:String
    var block:(()->Void)
    
    static func initialize() {
        
        register(name: "/currencyPreview") {
            
            let _: Observable<CurrencyPreviewResult?> = DataManager
                .fetchAndSubscribe(resource: .currencyPreview(fromAmount: 100,
                                                                 fromCurrency: "EUR",
                                                                 toCurrency: "JPY"))
        }
        
        register(name: "/currencyConversion") {
            
            let _: Observable<CurrencyConversionResult?> = DataManager
                .fetchAndSubscribe(resource: .currencyConversion(fromAmount: 100,
                                                                 fromCurrency: "EUR",
                                                                 toCurrency: "JPY"))
        }
        
        register(name: "/supportedCurrencies") {
            
            let _: Observable<CurrencyBalanceList?> = DataManager
                .fetchAndSubscribe(resource: .currencyBalances)
        }
        
    }
    
    static var list = Variable<[DemoEndpoint]>([])
    
    fileprivate static func register(name: String, action: @escaping (()->Void)) {
        let endpoint = DemoEndpoint(name: name, block: action)
        list.value.append(endpoint)
    }
    
}
