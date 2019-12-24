//
//  StyleHelper.swift
//  HomeModule
//
//  Created by Gerald on 23/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

struct StyleHelper {
    
    static func applyStyle(_ style: StyleProtocol?,
                           to view: UIButton?) {
        
        guard let element = view else { return }
        
        element.backgroundColor = style?.hm_buttonColor
        element.layer.cornerRadius = style?.hm_buttonCornerRadius ?? 0
        element.clipsToBounds = element.layer.cornerRadius > 0
    }
}
