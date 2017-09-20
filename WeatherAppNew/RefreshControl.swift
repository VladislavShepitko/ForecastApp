//
//  UpdateWeatherView.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/31/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@objc protocol RefreshDelegate{
    func startUpdating(refreshControl:RefreshControl)
}

class RefreshControl: UIRefreshControl {
    
    private var isAnimating:Bool = false
    private let maxHeight:CGFloat = 60
    private let offsetfromEarth:CGFloat = 2
    private var prevH:CGFloat = 0
    
    private lazy var maxDistance:CGFloat = {
        return self.earthHalfSize.width + self.satelliteHalfSize.width + self.offsetfromEarth
        }()
    private var satelliteOnOrbit = false
    weak var delegate:RefreshDelegate?
    
    @IBOutlet weak var timeView: UILabel!
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
        self.backgroundColor = UIColor.clearColor()
        self.tintColor = UIColor.clearColor()
        self.satelliteView.translatesAutoresizingMaskIntoConstraints = true
        self.earthView.translatesAutoresizingMaskIntoConstraints = true
        self.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func refresh(){
        print("update")
        self.satelliteView.alpha = 0
        if let delegate = self.delegate{
            delegate.startUpdating(self)
        }
    }
    
    func updateProgress( pullDistance:CGFloat){
        
        var refreshBounds = self.bounds
        //get middle of the view
        let midX = self.frame.width / 2.0
        var offsetY = pullDistance
        
        //get direction
        let dir = prevH < pullDistance ? 1: -1
        prevH = pullDistance
        
        //chack if offsetY = -0
        offsetY = offsetY < 0 ? offsetY * -1 : offsetY
        
        //print("pull distance:\(pullDistance)")
        /*if offsetY == 0 {
            self.endRefreshing()
            //return
        }*/
        if dir < 0 && pullDistance < maxHeight && self.refreshing {
            //print("up")
            offsetY = maxHeight
        }
        /*
        if pullDistance > maxHeight && dir < 0{
            print("up")
            offsetY = maxHeight
        }*/
        
        //instead of working with pullDistance we will work with offsetY
        // Set the Y coord of the graphics, based on pull distance
        let earthY:CGFloat = offsetY / 2.0 + 10 - self.earthHalfSize.height
        let earthX:CGFloat = midX - self.earthHalfSize.width
        
        // Calculate the pull ratio, between 0.0-1.0
        let pullRatio = min( max(offsetY, 0.0), maxHeight) / maxHeight
        let radius =  maxDistance * pullRatio
        
        //we need culculate satellite position based on new earth position
        let updatedEarthCenterX = earthX + self.earthHalfSize.width
        let updatedEarthCenterY = earthY + self.earthHalfSize.height
        
        //calculate satellite x and y position based on angle and distance from earth center
        var satelliteX = updatedEarthCenterX - self.satelliteHalfSize.width + CGFloat(sin(M_PI / 3)) * radius
        var satelliteY = updatedEarthCenterY - self.satelliteHalfSize.height + CGFloat(cos(M_PI / 3)) * -radius
        
        struct SattellitePosOnOrbit{
            static var x:CGFloat = 0
            static var y:CGFloat = 0
        }
        
        //when satellite comes to his correct position on earth orbit
        if fabsf(Float(radius) - Float(maxDistance)) <= 0.1 {
            satelliteOnOrbit = true
            SattellitePosOnOrbit.x = satelliteX
            SattellitePosOnOrbit.y = satelliteY
        }
        
        if satelliteOnOrbit || self.refreshing {
            satelliteX = SattellitePosOnOrbit.x
            satelliteY = SattellitePosOnOrbit.y
        }
        //print("sattellite on orbit: \(satelliteOnOrbit)")
        
        //set earth image to center of view based on pull distance
        var earthFrame = self.earthView.frame
        var satelliteFrame = self.satelliteView.frame
        
        earthFrame.origin.x = earthX
        earthFrame.origin.y = earthY
        
        satelliteFrame.origin.x = satelliteX
        satelliteFrame.origin.y = satelliteY
        
        //update items frame's
        self.earthView.frame = earthFrame
        self.satelliteView.frame = satelliteFrame
        
        if dir >= 1 || self.refreshing {
            self.satelliteView.alpha = pullRatio
        }
        self.earthView.alpha = pullRatio
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (self.refreshing && !self.isAnimating) {
            self.animateRefreshView()
        }
        
        refreshBounds.size.height = offsetY
        
        self.bounds = refreshBounds
        //print("radius: \(radius); ratio: \(pullRatio); dispance: \(offsetY);")
    }
    
    private func animateRefreshView(){
        print("start animation")
        self.isAnimating = true;
        
        //from http://ronnqvi.st/translate-rotate-translate/#fnref:matrixMultiplication
        /*
        CGPoint rotationPoint = // The point we are rotating around
            
        CGFloat minX   = CGRectGetMinX(view.frame);
        CGFloat minY   = CGRectGetMinY(view.frame);
        CGFloat width  = CGRectGetWidth(view.frame);
        CGFloat height = CGRectGetHeight(view.frame);
        CGPoint anchorPoint =  CGPointMake((rotationPoint.x-minX)/width,
            (rotationPoint.y-minY)/height);
        view.layer.anchorPoint = anchorPoint;
        view.layer.position = rotationPoint;
        
        CABasicAnimation *rotate =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotate.toValue = @(-M_PI_2); // The angle we are rotating to
        rotate.duration = 1.0;
        
        [view.layer addAnimation:rotate forKey:@"myRotationAnimation"];
        */
        
        let rotationPoint = self.earthView.center
        let minX   = CGRectGetMinX(self.satelliteView.frame)
        let minY   = CGRectGetMinY(self.satelliteView.frame)
        let width  = CGRectGetWidth(self.satelliteView.frame)
        let height = CGRectGetHeight(self.satelliteView.frame)
        
        let anchorPoint =  CGPointMake((rotationPoint.x - minX) / width, (rotationPoint.y - minY) / height)
        
        self.satelliteView.layer.anchorPoint = anchorPoint;
        self.satelliteView.layer.position = rotationPoint;
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = CGFloat(M_PI * 2)
        animation.duration = 1.7
        animation.delegate = self
        animation.removedOnCompletion = true
        self.satelliteView.layer.addAnimation(animation, forKey: "satelliteAnimation")
    }
    
    func stopRefreshing(){
        self.satelliteView.layer.removeAllAnimations()
        self.satelliteView.alpha = 0
        self.resetAnimation()
        self.endRefreshing()
    }
    
    func stopRefreshing(finishTime:String){
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            UIView.animateWithDuration(0.2, animations: { [unowned self] in
                self.timeView.text = "Updated: \(finishTime)"
            })
        }
        /*UIView.animateWithDuration(0.1) { [unowned self] in
            self.satelliteView.alpha = 0
        }*/
        self.stopRefreshing()
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        print("stop animation")
        if (self.refreshing) {
            self.animateRefreshView()
        }else {
            self.resetAnimation()
        }
    }
    
    private func resetAnimation(){
        print("reset state")
        self.isAnimating = false;
        self.satelliteOnOrbit = false;
    }
    
}
extension UIRefreshControl {
    func refreshManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: false)
        }
        beginRefreshing()
        self.sendActionsForControlEvents(.ValueChanged)
    }
}