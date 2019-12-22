//
//  ViewController.swift
//  Demo
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UITableViewController {

    private struct Constants {
        static let cellIdentifier = "UITableViewCell"
    }
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DemoEndpoint.initialize()
        initializeBinding()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initializeBinding() {
        
        DemoEndpoint.list
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: Constants.cellIdentifier,
                                         cellType: UITableViewCell.self))
            { (row, element, cell) in
                cell.textLabel?.text = element.name
            }
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { current in
                let data = DemoEndpoint.list.value[current.row]
                data.block()
            })
            .disposed(by: bag)
        
    }

}

