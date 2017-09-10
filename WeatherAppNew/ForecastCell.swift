//
//  DetailedWeatherCollectionViewCell.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    @IBOutlet weak var tempView: UILabel!
    @IBOutlet weak var tempMinView: UILabel!
    @IBOutlet weak var tempMaxView: UILabel!
    @IBOutlet weak var weatherDescriptionView: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    
    static var height:CGFloat = 0
    static var alpha:CGFloat = 0
    private var isExpanded = false
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var humidityView: UILabel!
    @IBOutlet weak var windSpeedView: UILabel!
    @IBOutlet weak var windDirectionView: UILabel!
    
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
        let gestureRecogn = UITapGestureRecognizer(target: self, action: "onTap:")
        gestureRecogn.numberOfTapsRequired = 2 
        self.addGestureRecognizer(gestureRecogn)
        //self.detailsHeight.constant = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func onTap(sender:UITapGestureRecognizer){
        if sender.numberOfTouches() == 2 {
            return
        }
        print("double tap")
        
        ForecastCell.height = isExpanded ? 0: 150
        ForecastCell.alpha = isExpanded ? 0: 1
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [], animations: { () -> Void in
            self.detailsHeight.constant = ForecastCell.height
            self.detailsView.alpha = ForecastCell.alpha
            self.layoutIfNeeded()
            }, completion: nil)
        
        isExpanded = !isExpanded
    }
}

