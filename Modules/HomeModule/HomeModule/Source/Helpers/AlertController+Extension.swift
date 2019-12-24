//
//  AlertController+Extension.swift
//  HomeModule
//
//  Created by Gerald on 22/12/2019.
//  Copyright © 2019 Gerald. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    func addActions(_ actions: [UIAlertAction],
                    includesCancel: Bool = false) {
        
        var allActions = actions
        
        if (includesCancel) {
            
            allActions.append(UIAlertAction(title: ModuleConstants.cancelButtonTitle,
                                            style: .cancel,
                                            handler: nil))
            
        }
        
        allActions.forEach { [weak self] in self?.addAction($0) }
        
    }
}
