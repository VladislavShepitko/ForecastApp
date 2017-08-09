//
//  WeatherCollectionViewCell.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit


class WeatherCollectionViewCell: BaseCollectionViewCell {
    var temperatureView:UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.text = "25º"
        label.font = UIFont(name: Fonts.UltraLightText.rawValue, size: 86)
        //label.textColor = UIColor.grayColor()
        return label
        }()
    let maxTemperatureView:UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.text = "⬆️ 25"
        label.font = UIFont(name: Fonts.LightText.rawValue, size: 19)
        //label.textColor = UIColor.grayColor()
        return label
        }()
    let minTemperatureView:UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.text = "⬇️ 19"
        label.font = UIFont(name: Fonts.LightText.rawValue, size: 19)
        //label.textColor = UIColor.grayColor()
        return label
        }()
    let descriptionView:UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.text = "Mostly cloudly"
        label.font = UIFont(name: Fonts.LightText.rawValue, size: 21)
        //label.textColor = UIColor.grayColor()
        return label
        }()
    let iconView:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Icon.rawValue, size: 35)
        label.text = Climacon.SleetSun.rawValue
        //label.textColor = UIColor.grayColor()
        return label
        }()
    
    override func setupView(){
        super.setupView()
        
        self.addSubview(temperatureView)
        self.addSubview(maxTemperatureView)
        self.addSubview(minTemperatureView)
        self.addSubview(descriptionView)
        self.addSubview(iconView)

        
        self.addConstraintsWithFormat("H:[v0]-5-[v1]-10-|", views: minTemperatureView,maxTemperatureView)
        self.addConstraintsWithFormat("H:[v0(32)]-10-[v1]-10-|", views: iconView, temperatureView)
        self.addConstraintsWithFormat("H:[v0]-10-|", views: descriptionView)
        
        self.addConstraintsWithFormat("V:[v0]-5-[v1]-5-[v2]-30-|", views: descriptionView, temperatureView, minTemperatureView)
        self.addConstraintsWithFormat("V:[v0(32)]-20-[v1]-30-|", views: iconView, maxTemperatureView)
    }
    
}
