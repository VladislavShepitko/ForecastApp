//
//  Extensions.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format:String, views:UIView...) {
        var viewsDict:[String:UIView] = [:]
        
        for (index,view) in views.enumerate() {
            let key = "V\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict[key] = view
        }
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
    }
}