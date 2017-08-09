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
        layout.scrollDirection = .Vertical
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        return cv
        }()
    
    override func setupView() {
        super.setupView()
        self.titleView.text = "Weather for weak"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(WeatherWeakDayCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.containerView.addSubview(collectionView)
        self.containerView.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        self.containerView.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
    }
}
extension WeatherForWeakCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of hours to end of the day
        return 5
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 30)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
class WeatherWeakDayCollectionViewCell: BaseCollectionViewCell {
    var dayOfWeakView:UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.text = "monday"
        label.font = UIFont(name: Fonts.LightText.rawValue, size: 16)
        label.textColor = UIColor.whiteColor()
        return label
        }()
    let maxTemperatureView:UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.text = "25"
        label.font = UIFont(name: Fonts.LightText.rawValue, size: 16)
        label.textColor = UIColor.whiteColor()
        return label
        }()
    let minTemperatureView:UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.text = "19"
        label.font = UIFont(name: Fonts.LightText.rawValue, size: 16)
        label.textColor = UIColor.whiteColor()
        return label
        }()
    let iconView:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Icon.rawValue, size: 20)
        label.text = Climacon.Sunrise.rawValue
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        return label
        }()
    let separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
        }()
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = UIColor.clearColor()
        
        addSubview(dayOfWeakView)
        addSubview(iconView)
        addSubview(maxTemperatureView)
        addSubview(minTemperatureView)
        addSubview(separatorView)
        addConstraintsWithFormat("H:|-[v0(100)][v1][v2]-10-[v3]-|", views: dayOfWeakView, iconView, maxTemperatureView,minTemperatureView)
        addConstraintsWithFormat("H:|-[v0]-|", views: separatorView)
        addConstraintsWithFormat("V:|-[v0]-|", views: dayOfWeakView)
        addConstraintsWithFormat("V:|-[v0]-|", views: iconView)
        addConstraintsWithFormat("V:|-[v0]-|", views: maxTemperatureView)
        addConstraintsWithFormat("V:|-[v0]-[v1(1)]|", views: minTemperatureView,separatorView)
    }
}
