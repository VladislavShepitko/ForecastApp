//
//  ForecastHeader.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/9/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class ForecastHeader: UICollectionReusableView {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var todayView: UILabel!
    @IBOutlet weak var cityView: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var dateView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateTodayView(text:String){
        let todayConstraint = todayView.getConstraint(with: "todayLeading")
        
        todayConstraint?.constant = todayView.frame.width
        todayView.alpha = 0
        UIView.animateWithDuration(0.5) { [unowned self, weak todayConstraint] in
            self.todayView.text = text
            todayConstraint?.constant = 0
            self.todayView.alpha = 1
        }
        
    }
}
