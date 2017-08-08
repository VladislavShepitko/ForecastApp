//
//  WeatherForDayCollectionViewCell.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class WeatherForDayCollectionViewCell: BaseCollectionViewCell {
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
        }()
    override func setupView() {
        super.setupView()
        self.collectionView.registerClass(WeatherForOneHourCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clearColor()
        
        self.addSubview(collectionView)
        self.addSubview(detailsView)
        
        self.addConstraintsWithFormat("H:|[v0]|", views: detailsView)
        self.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        self.addConstraintsWithFormat("V:|[v0][v1(70)]|", views: detailsView,collectionView)
    }
}

extension WeatherForDayCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}


class WeatherForOneHourCollectionViewCell:BaseCollectionViewCell {
    var timeView:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.UltraLightText.rawValue, size: 14)
        label.text = "19:00"
        return label
        
        }()
    var temperatureView:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.UltraLightText.rawValue, size: 14)
        label.text = "18"
        return label
        
        }()
    var iconView:UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: Fonts.Icon.rawValue, size: 20)
        label.text = Climacon.Sun.rawValue
        return label
        
        }()
    override func setupView() {
        addSubview(timeView)
        addSubview(temperatureView)
        addSubview(iconView)
        
        self.addConstraintsWithFormat("V:|[v0]|", views: timeView)
        self.addConstraintsWithFormat("V:|[v0]|", views: iconView)
        self.addConstraintsWithFormat("V:|[v0]|", views: temperatureView)
        self.addConstraintsWithFormat("V:|[v0(20)]-[v1]-[v2(20)]|", views: timeView,iconView,temperatureView)
        
    }
    
}
