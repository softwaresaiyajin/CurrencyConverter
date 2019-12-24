//
//  AppDelegate.swift
//  Demo
//
//  Created by Gerald on 18/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import UIKit
import HomeModule
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let controller = HomeViewController.create(dataProvider: self,
                                                   routeProvider: nil)
        let navcon = UINavigationController(rootViewController: controller)
        window?.rootViewController = navcon
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: StyleProtocol {
    
    var hm_buttonColor: UIColor? { return UIColor(red: 16/255, green: 117/255, blue: 193/255, alpha: 1)}
    
    var hm_buttonCornerRadius: CGFloat { return 10 }
    
}


extension AppDelegate: DataProviderProtocol {
    
    func hm_getStyle() -> Observable<StyleProtocol?> {
        return Observable.just(self)
    }
    
    func hm_getConvertedAmountPreview(_ amount: Double,
                                      from originCurrency: String,
                                      to destinationCurrency: String) -> Observable<Double> {
        return Observable.just(ConversionDemoApi.getConvertedAmountPreview(amount,
                                                                           from: originCurrency,
                                                                           to: destinationCurrency))
    }
    
    func hm_submitRequest(amount: Double,
                          from originCurrency: String,
                          to destinationCurrency: String) -> Observable<ConversionResultProtocol?> {
        return Observable.just(ConversionDemoApi.convertAmount(amount,
                                                               from: originCurrency,
                                                               to: destinationCurrency))
    }
    
    func hm_getCurrencyBalances() -> Observable<[CurrencyBalanceProtocol]> {
        
        return Observable.just(ConversionDemoApi.supportedCurrencies)
    }
}
