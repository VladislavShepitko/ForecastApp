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
        menuButton.tintColor = UIColor.blackColor()
        menuButton.imageView!.image = menuButton.imageView!.image?.imageWithRenderingMode(.AlwaysTemplate)
        menuButton.addTarget(self, action: "showMenu", forControlEvents: .TouchUpInside)
    }
    
    func updateTodayView(progress:CGFloat, data text:String){
        //self.todayView.text = text
    }
    func showMenu(){
        /*guard let vc = (self.n where
        vc.revealViewController() != nil else {
            return
        }*/
        
    }
}
