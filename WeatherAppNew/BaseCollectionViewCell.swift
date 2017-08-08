//
//  BaseCollectionViewCell.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
    }
}

class BaseWeatherCollectionViewCell: BaseCollectionViewCell {
    var titleView:UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.text = "Title "
        label.font = UIFont(name: Fonts.LightText.rawValue, size: 18)
        label.textAlignment = .Right
        label.textColor = UIColor.whiteColor()
        return label
        }()
    var containerView:UIView = {
        let view = UIView()
        view.userInteractionEnabled = true
        return view
        }()
    override func setupView() {
        super.setupView()
        addSubview(titleView)
        addSubview(containerView)
        self.backgroundColor = UIColor(white: 0.1, alpha: 0.95)
        self.layer.cornerRadius = 5
        //addConstraintsWithFormat("V:|[v0(5)]", views: separationView)
        
        addConstraintsWithFormat("V:|-[v0(17)]-[v1]|", views: titleView, containerView)
        addConstraintsWithFormat("H:|[v0]-10-|", views: titleView)
        
        
        addConstraintsWithFormat("H:|[v0]|", views: containerView)
    }
}
