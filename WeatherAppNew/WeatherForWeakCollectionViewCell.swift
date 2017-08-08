//
//  WeatherForWeakCollectionViewCell.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class WeatherForWeakCollectionViewCell: BaseWeatherCollectionViewCell {
    
    let cellIdentifier = String(self)
    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        return cv
        }()
    
    override func setupView() {
        super.setupView()
        self.titleView.text = "Weather for weak"
        self.containerView.addSubview(collectionView)
        
        
    }
}
