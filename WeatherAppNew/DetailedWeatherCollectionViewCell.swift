//
//  DetailedWeatherCollectionViewCell.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class DetailedWeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tempView: UILabel!
    @IBOutlet weak var tempMinView: UILabel!
    @IBOutlet weak var tempMaxView: UILabel!
    @IBOutlet weak var weatherDescriptionView: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var humidityView: UILabel!
    @IBOutlet weak var windSpeedView: UILabel!
    @IBOutlet weak var windDirectionView: UILabel!
    @IBOutlet weak var forecastForTodayView: UICollectionView!
    
    var model:WeatherViewModel? = nil {
        didSet{
            model?.temp.subscribe({[unowned self] value in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tempView.text = value
                })
                })
            model?.tempMin.subscribe({[unowned self] value in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tempMinView.text = value
                })
                })
            model?.tempMax.subscribe({[unowned self] value in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tempMaxView.text = value
                })
                })
            model?.weatherDescription.subscribe({[unowned self] value in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.weatherDescriptionView.text = value
                })
                })
            
            model?.icon.subscribe({[unowned self] value in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.weatherIconView.image = value
                })
                })
            model?.humidity.subscribe({[unowned self] value in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.humidityView.text = value
                })
                })
            model?.windDirection.subscribe({[unowned self] value in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.windDirectionView.text = value
                })
                })
            model?.windSpeed.subscribe({[unowned self] value in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.windSpeedView.text = value
                })
                })
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        forecastForTodayView.delegate = self
        forecastForTodayView.dataSource = self
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        forecastForTodayView.collectionViewLayout.invalidateLayout()
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
        return CGSize(width: 50, height: forecastForTodayView.frame.height - 1)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
}
