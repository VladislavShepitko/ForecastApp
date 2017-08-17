//
//  WeatherForDayCollectionViewCell.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class WeatherViewCell: UICollectionViewCell {
    /*
    let cellIdentifier = String(self)
    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        return cv
        }()
    
    var detailsView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.purpleColor()
        return view
        }()*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        self.layer.anchorPoint.x = 0.5
        self.layer.anchorPoint.y = 0.5
    }
    /*
    func setupView() {
        self.collectionView.registerClass(WeatherForOneHourCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clearColor()
        
        self.addSubview(collectionView)
        self.addSubview(detailsView)
        
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.addConstraintsWithFormat("H:|[v0]|", views: detailsView)
        self.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        self.addConstraintsWithFormat("V:|-[v0][v1(70)]-|", views: detailsView,collectionView)
    }*/
}
/*
extension WeatherView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of hours to end of the day
        return 12
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! WeatherForOneHourCollectionViewCell
        if indexPath.item == 0 {
            cell.timeView.text = "Now"
        }else {            
            cell.timeView.text = "18:00"
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 70)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
*/
/*
class WeatherForOneHourCollectionViewCell:UICollectionViewCell {
    var timeView:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.LightText.rawValue, size: 15)
        label.text = "19:00"
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        return label
        
        }()
    var temperatureView:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.LightText.rawValue, size: 15)
        label.text = "18º"
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        return label
        
        }()
    var iconView:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Icon.rawValue, size: 20)
        label.text = Climacon.Sun.rawValue
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        return label
        
        }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        addSubview(timeView)
        addSubview(temperatureView)
        addSubview(iconView)
        
        self.addConstraintsWithFormat("H:|[v0]|", views: timeView)
        self.addConstraintsWithFormat("H:|[v0]|", views: iconView)
        self.addConstraintsWithFormat("H:|[v0]|", views: temperatureView)
        self.addConstraintsWithFormat("V:|-[v0(13)]-[v1]-[v2(13)]-|", views: timeView,iconView,temperatureView)
        
    }
    
}
*/