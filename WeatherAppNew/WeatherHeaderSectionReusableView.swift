//
//  WeatherHeaderSectionReusableView.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/9/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class WeatherHeaderSectionReusableView: UICollectionReusableView {
    var menuButtonView:UIButton = {
        let btn = UIButton (type: .System)
        btn.setImage(UIImage(named: "002-mark")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        btn.tintColor = UIColor.whiteColor()
        return btn
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(menuButtonView)
        addConstraintsWithFormat("H:|-[v0(30)]", views: menuButtonView)
        addConstraintsWithFormat("V:|-20-[v0(30)]", views: menuButtonView)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
