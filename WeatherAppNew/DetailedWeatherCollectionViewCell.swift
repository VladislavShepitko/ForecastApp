//
//  DetailedWeatherForToDayCollectionViewCell.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/9/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class DetailedWeatherCollectionViewCell: BaseWeatherCollectionViewCell
{
    let cellIdentifier = String(self)
    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        return cv
        }()
    
    override func setupView() {
        super.setupView()
        self.titleView.text = "Details"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(DetailedWeatherForToDayCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.containerView.addSubview(collectionView)
        self.containerView.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        self.containerView.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
    }

}
extension DetailedWeatherCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
class DetailedWeatherForToDayCollectionViewCell: BaseCollectionViewCell {
    var label:UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.text = "Sun rise:"
        label.font = UIFont(name: Fonts.LightText.rawValue, size: 16)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Right
        return label
        }()
    let value:UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.text = "05:25"
        label.font = UIFont(name: Fonts.LightText.rawValue, size: 16)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Left
        return label
        }()
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = UIColor.clearColor()
        
        addSubview(label)
        addSubview(value)
        addConstraintsWithFormat("H:|-[v0(\(self.frame.width / 2))]-5-[v1]", views: label, value)
        addConstraintsWithFormat("V:|-[v0]-|", views: label)
        addConstraintsWithFormat("V:|-[v0]-|", views: value)
    }
}