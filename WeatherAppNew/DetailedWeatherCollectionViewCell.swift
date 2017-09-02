//
//  DetailedWeatherCollectionViewCell.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class DetailedWeatherCollectionViewCell: UICollectionViewCell {
    
    var weather:Weather.Main?
    
    @IBOutlet weak var weatherForHoursCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        weatherForHoursCollectionView.delegate = self
        weatherForHoursCollectionView.dataSource = self
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        weatherForHoursCollectionView.collectionViewLayout.invalidateLayout()
    }
}
extension DetailedWeatherCollectionViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of hours to end of the day
        return 12
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeatherForHourCell", forIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //print("bounds: \(self.frame)")
        return CGSize(width: 50, height: weatherForHoursCollectionView.frame.height - 1)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
}
