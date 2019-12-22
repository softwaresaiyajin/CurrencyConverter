//
//  HomeViewController.swift
//  HomeModule
//
//  Created by Gerald on 21/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

public final class HomeViewController: UITableViewController {

    private struct Constants {
        
        static let cellIdStep = "TransactionStepTableViewCell"
        
        static let cellIdBalance = "BalanceListTableViewCell"
        
        static let controllerTitle = "Currency converter"
        
        static let controllerName = "HomeViewController"
        
    }
    
    private lazy var bag: DisposeBag = { return DisposeBag() }()
    
    private var viewModel: ViewModel?
    
    @IBOutlet weak var submitButton: UIButton!
    
    public static func create(dataProvider: DataProviderProtocol?,
                              routeProvider: RouteProviderProtocol?) -> HomeViewController {
        let controller = ModuleConstants.storyBoard.instantiateInitialViewController() as! HomeViewController
        
        controller.viewModel = ViewModel(dataProvider: dataProvider,
                                         routeProvider: routeProvider,
                                         disposeBag: controller.bag)
        return controller
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        title = Constants.controllerTitle;
        initializeBinding()
        processUIAdjustments()
        // Do any additional setup after loading the view.
    }
    
    private func processUIAdjustments() {
        
        submitButton.layer.cornerRadius = 10
        submitButton.clipsToBounds = true
        submitButton.rx
            .controlEvent(.touchUpInside)
            .asObservable()
            .subscribe(onNext : { [weak self] current in
                
                self?.viewModel?.submitConversionRequest()
                    .subscribe(onNext : { [weak self] current in
                        
                        let message = current?.hm_message
                        let title = (current?.hm_isSuccess ?? false)
                            ? "Currency converted"
                            : "Conversion failed"
                        let alert = UIAlertController(title: title,
                                                      message: message,
                                                      preferredStyle: .alert)
                        alert.addActions([], includesCancel: true)
                        self?.present(alert, animated: true, completion: nil)
                        
                    }).disposed(by: self?.bag ?? DisposeBag())
                
            }).disposed(by: bag)
    }
    
    private func configureTransactionCell(_ cell: TransactionStepTableViewCell,
                                          step: TransactionType) {
        
        let isReceive = step.isOutput
        let prefix = isReceive ? "+ " : "";
        
        cell.iconImage = UIImage(named: step.icon,
                                 in: ModuleConstants.bundle,
                                 compatibleWith: nil)
        cell.transactionName = step.name
        cell.isTextFieldEnabled = !step.isOutput
        cell.currencyBalanceTextColor = isReceive ? UIColor.green : UIColor.black
        
        step.currency
            .asObservable()
            .map( { $0?.hm_currencyCode })
            .bind(to: cell.currencyCodeLabel.rx.text)
            .disposed(by: bag)
        
        step.displayAmount
            .asObservable()
            .map { (data) -> String in
                return String.init(format: "\(prefix)%.2f", max(0, data))
            }.bind(to: cell.currencyBalanceTextField.rx.text)
        .disposed(by: bag)
        
        if (!isReceive) {
            
            let sellObservable = cell.currencyBalanceTextField.rx
                .controlEvent(.editingChanged)
                .asObservable()
            
            sellObservable
                .map { (_) -> Bool in
                    guard let number = Double(cell.currencyBalanceTextField.text ?? "") else {
                        return false
                    }
                    return number > 0
                }.bind(to: submitButton.rx.isEnabled)
                .disposed(by: bag)
            
            sellObservable
                .subscribe(onNext : { [weak self] current in
                    
                    if let amount = Double(cell.currencyBalanceTextField.text ?? "") {
                        self?.viewModel?.convertAmount(amount)
                    }
                })
                .disposed(by: bag)
        }
        
        cell.expandButton.rx
            .controlEvent(.touchUpInside)
            .asObservable()
            .subscribe(onNext : { [weak self] _ in
                
                let alertController = UIAlertController(title: nil,
                                                        message: "Choose Currency",
                                                        preferredStyle: .actionSheet)
                
                let handler: (UIAlertAction) -> Void = { [weak self] (action) in
                    guard action.title != ModuleConstants.cancelButtonTitle else { return }
                    self?.viewModel?.setCurrency(action.title, step: step)
                }
                
                let actions = self?.viewModel?.getCurrencyOptions(for: step)
                    .map({ UIAlertAction(title: $0.hm_currencyCode,
                                         style: .default,
                                         handler: handler) }) ?? []
               
                alertController.addActions(actions, includesCancel: true)
                self?.present(alertController, animated: true, completion: nil)
                
            })
            .disposed(by: bag)
    }

    private func initializeBinding() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionData>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
          
                switch (item) {
                    
                case .balances(let data):
                    
                    let view = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdBalance,
                                                             for: indexPath) as! BalanceListTableViewCell
                    view.items = data
                    
                    return view
                    
                case .transactionStep(let data):
                    
                    let view = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdStep,
                                                             for: indexPath) as! TransactionStepTableViewCell
                    
                    self?.configureTransactionCell(view, step: data)
                    
                    return view;
                }
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }

        viewModel?.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel?.fetchData()

    }
}
