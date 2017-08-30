//
//  UpdateWeatherBar.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/30/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class UpdateWeatherBar: UIView {
    
    var height:NSLayoutConstraint?
    weak var anotherHeight:NSLayoutConstraint?
    let maxHeight:CGFloat = 70
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        if self.constraints.count > 0 {
            for constraint in self.constraints {
                if constraint.identifier == "height"{
                    self.height = constraint
                    break
                }
            }
        }
        if height == nil {
            height = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 0)
            height?.identifier = "height"
        }
        print("constraint: \(height)")
        height?.constant = 0
        layoutIfNeeded()
    }
    
    func progressView(progress:CGFloat, completion:()->Void){
        let currentHeight = progress * (maxHeight * 3)
        print("height: \(currentHeight)")
        /*
        self.height?.constant = currentHeight
        self.anotherHeight?.constant  = 0
        UIView.animateWithDuration(0.8) { () -> Void in
            self.layoutIfNeeded()
        }
        */
    }
    
}
