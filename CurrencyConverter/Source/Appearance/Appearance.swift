//
//  Appearance.swift
//  CurrencyConverter
//
//  Created by Gerald on 23/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation
import UIKit

struct Appearance {
    
    var themeColor: UIColor? { return UIColor(red: 25/255, green: 153/255, blue: 215/255, alpha: 1) }
    
    let buttonCornerRadius: CGFloat = 10
    
    var navigationBarColor: UIColor? { return themeColor }
    
    var navigationBarTitleColor: UIColor? { return .white }
    
    var navigationBarFont: UIFont? { return UIFont(name: "Helvetica", size: 20) }
}
