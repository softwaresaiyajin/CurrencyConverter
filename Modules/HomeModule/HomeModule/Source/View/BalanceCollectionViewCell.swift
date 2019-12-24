//
//  BalanceCollectionViewCell.swift
//  HomeModule
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import UIKit

class BalanceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

// MARK: -
// MARK: BalanceCollectionViewCell for Custom UI Properties
extension BalanceCollectionViewCell {
    
    var balance: String? {
        get { return balanceLabel?.text }
        set { balanceLabel?.text = newValue }
    }
}
