//
//  TitleView.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/17/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class TitleView: UIView {
    var imageView:UIImageView = {
        let view = UIImageView()
        view.image  = UIImage(named: "017-cloudy")?.imageWithRenderingMode(.AlwaysTemplate)
        view.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        view.tintColor = .whiteColor()
        return view
        }()
    var titleView:UILabel = {
        let view = UILabel()
        view.text = "Kharkiv"
        view.font = UIFont(name: Fonts.LightText.rawValue, size: 18)
        view.textColor = .whiteColor()
        return view
        }()
    var timeView:UILabel = {
        let view = UILabel()
        view.text = "Last update: 18:36"
        view.font = UIFont(name: Fonts.LightText.rawValue, size: 12)
        view.textColor = .whiteColor()
        return view
        }()
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleView)
        addSubview(timeView)
        addConstraintsWithFormat("V:|-5-[v0(32)]", views: imageView)
        addConstraintsWithFormat("H:|[v0(32)]-5-[v1]", views: imageView,titleView)
        addConstraintsWithFormat("V:|[v0][v1]", views: titleView,timeView)
        addConstraintsWithFormat("H:|-37-[v0]", views: timeView)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
