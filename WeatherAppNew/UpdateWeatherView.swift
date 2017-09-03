//
//  UpdateWeatherView.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/31/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class UpdateWeatherView: UIView {
    var activityIndicator:UIActivityIndicatorView?
    
    var height:NSLayoutConstraint!
    
    let MAX_HEIGHT:CGFloat = 110
    let WAIT_TIME:NSTimeInterval = 3
    
    var timer: NSTimer!
    private var isOpened:Bool = false
    private var indicator:UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        height = self.getConstraint(with: "height")
        height.constant = 0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    func addIndicator(){
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        addSubview(indicator)
        indicator.startAnimating()
    }
    
    func show(onOpen:()->Void){
        if isOpened { return }
        self.height.constant = self.MAX_HEIGHT
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [],   animations: { () -> Void in
            self.layoutIfNeeded()
            }) { _ in
               self.startTimer()
               self.isOpened = true
               onOpen()
               dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.addIndicator()
               })
        }
    }
    func close(){
        self.height.constant = 0
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.layoutIfNeeded()
            })
        isOpened = false
    }
    private func startTimer(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.timer = NSTimer.scheduledTimerWithTimeInterval(self.WAIT_TIME, target: self, selector: "finishUpdate:", userInfo: nil, repeats: false)
        }
    }
    func finishUpdate(timer:NSTimer){
        self.close()
        self.indicator.stopAnimating()
    }
}
