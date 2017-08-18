//
//  WeatherContainer.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class WeatherContainerView: UIView {
    let cellIdentifier = String(self)
    
    let contantView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.greenColor()
        return view
        }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.registerClass(WeatherForOneHourCollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
        }()
    
    convenience init()
    {
        self.init(frame:CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    func setupView(){
        addSubview(contantView)
        addSubview(collectionView)
        addConstraintsWithFormat("V:|[v0][v1(80)]|", views: contantView,collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: contantView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension WeatherContainerView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
