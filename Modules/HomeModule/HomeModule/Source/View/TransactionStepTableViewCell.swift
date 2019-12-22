//
//  CurrencyExchangeTableViewCell.swift
//  HomeModule
//
//  Created by Gerald on 21/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import UIKit

class TransactionStepTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var transactionNameLabel: UILabel!
    
    @IBOutlet weak var currencyCodeLabel: UILabel!
    
    @IBOutlet weak var currencyBalanceTextField: UITextField!
    
    @IBOutlet weak var expandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension TransactionStepTableViewCell {
    
    var currencyBalanceTextColor: UIColor?
    {
        get { return currencyBalanceTextField?.textColor }
        set { currencyBalanceTextField.textColor = newValue }
    }
    
    var isTextFieldEnabled: Bool
    {
        get { return currencyBalanceTextField?.isUserInteractionEnabled ?? false }
        set { currencyBalanceTextField.isUserInteractionEnabled = newValue }
    }
    
    var iconImage: UIImage?
    {
        get { return iconImageView?.image }
        set { iconImageView?.image = newValue }
    }
    
    var transactionName: String?
    {
        get { return transactionNameLabel?.text }
        set { transactionNameLabel?.text = newValue }
    }
    
    var currencyCode: String?
    {
        get { return currencyCodeLabel?.text }
        set { currencyCodeLabel?.text = newValue }
    }
    
    var balance: String?
    {
        get { return currencyBalanceTextField?.text }
        set { currencyBalanceTextField?.text = newValue }
    }
    
}
