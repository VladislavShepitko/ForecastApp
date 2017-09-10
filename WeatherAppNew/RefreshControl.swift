//
//  UpdateWeatherView.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/31/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit



class RefreshControl: UIRefreshControl {
    typealias Completion = (()->Void)
    var onComplete: Completion?
    
    var isAnimation:Bool = false
    var isStartedToAnimate:Bool = false
    
    @IBOutlet weak var satelliteView: UIImageView!
    @IBOutlet weak var earthView: UIImageView!
    
    private var earthHalfSize:CGSize{
        return CGSize(width: self.earthView.frame.size.width / 2.0, height: self.earthView.frame.size.height / 2.0)
    }
    private var satelliteHalfSize:CGSize{
        return CGSize(width: self.satelliteView.frame.size.width / 2.0, height: self.satelliteView.frame.size.height / 2.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.redColor()
        self.satelliteView.translatesAutoresizingMaskIntoConstraints = true
        self.earthView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    let maxHeight:CGFloat = 100
    var direction:Int = 1
    var prevDist:CGFloat = 0
    var offsetY:CGFloat = 1
    
    func updateProgress(bounds:CGRect, pullDistance:CGFloat){
        
        var refreshBounds = bounds
        //get middle of the view
        let midX = self.frame.width / 2.0
        
        //define direction of swipe
        direction = prevDist < pullDistance ? 1 : -1
        prevDist = pullDistance
        print("direction: \(direction)")
        
        //update refresh view bounds
        if direction < 0  && pullDistance < maxHeight{
            offsetY = maxHeight
        }else {
            offsetY = pullDistance
        }
        
        //instead of working with pullDistance we will work with offsetY
        // Set the Y coord of the graphics, based on pull distance
        let earthY = offsetY / 2.0 - self.earthHalfSize.height
        let earthX = midX - self.earthHalfSize.width
        
        // Calculate the pull ratio, between 0.0-1.0
        let pullRatio = min( max(offsetY, 0.0), maxHeight) / maxHeight;
        
        
        
        
        var earthFrame = self.earthView.frame
        //set earth image to center of view based on pull distance
        earthFrame.origin.x = earthX
        earthFrame.origin.y = earthY
        //update earth frame
        self.earthView.frame = earthFrame
        //self.earthView.alpha = pullRatio
        
        
        
        
        refreshBounds.size.height = offsetY
        
        self.frame = refreshBounds
        print("self: \(self.frame); ratio: \(pullRatio); dispance: \(pullDistance);")
    }
    func prepareForAnimation(){
        
    }
    func startAnimation(){
        print("start animation")
        
    }
    
}
