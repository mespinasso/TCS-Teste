//
//  UIViewController+ActivityIndicator.swift
//  TCS-Teste
//
//  Created by Matheus Coelho Espinasso on 02/09/18.
//  Copyright © 2018 Matheus Coelho Espinasso. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func prepareActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
    }
}
