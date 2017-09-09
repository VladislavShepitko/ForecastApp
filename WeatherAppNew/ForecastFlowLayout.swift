//
//  ForecastFlowLayout.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/9/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class ForecastFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.sectionHeadersPinToVisibleBounds = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
    }*/
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        
        attributes?.alpha = 0
        
        return attributes
    }
}
