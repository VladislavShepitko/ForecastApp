//
//  StackOfStacks.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/22/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class StackOfStacks: UIStackView {

    func addItems(items:[UIView])
    {
        let newStack = UIStackView(arrangedSubviews: items)
        newStack.axis = .Horizontal
        newStack.distribution = .FillEqually
        addArrangedSubview(newStack)
        
    }

}
