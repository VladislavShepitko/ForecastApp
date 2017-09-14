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
    
    var model:ForecastViewModel? = nil {
        didSet{
            if let model = model{
                dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                    self.tempView.text = model.temp
                    self.tempMinView.text = model.tempMin
                    self.tempMaxView.text = model.tempMax
                    self.weatherDescriptionView.text = model.weatherDescription
                    self.weatherIconView.image = model.icon
                    
                    self.humidityView.text = model.humidity
                    self.windSpeedView.text = model.wSpeed
                    self.windDirectionView.text = model.wDirection
                    //need update measure units
                    //and snow
                })
            }
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

