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
    override func setupView() {
        super.setupView()
        self.collectionView.registerClass(WeatherForOneHourCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        self.addConstraintsWithFormat("H:|-[v0]-|", views: collectionView)
        self.addConstraintsWithFormat("V:|-[v0(30)]-|", views: collectionView)
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
        return CGSize(width: self.bounds.height, height: self.bounds.height)
    }
}


class WeatherForOneHourCollectionViewCell:BaseCollectionViewCell {
    
    override func setupView() {
        self.backgroundColor = UIColor.redColor()
    }
    
}
