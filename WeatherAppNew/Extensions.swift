//
//  Extensions.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgbColor(red:CGFloat,green:CGFloat, blue:CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension Double {
    func clamp(minValue:Double,maxValue:Double) -> Double {
        if self < minValue {
            return minValue
        }else if  self > maxValue {
            return maxValue
        }else {
            return self
        }
    }
}
extension UIView {
    func addConstraintsWithFormat(format:String, views:UIView...) {
        var viewsDict:[String:UIView] = [:]
        
        for (index,view) in views.enumerate() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict[key] = view
        }
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
    }
}
extension Double {
    var radians:Double{
        get{
            return self * M_PI / 180.0
        }
    }
    var degrees:Double {
        get {
            return self / 180.0 * M_PI
        }
    }
}

func + (lp:CGPoint, rp:CGPoint) -> CGPoint
{
    return CGPoint(x: lp.x + rp.x, y: lp.y + rp.y)
}
func - (lp:CGPoint, rp:CGPoint) -> CGPoint
{
    return CGPoint(x: lp.x - rp.x, y: lp.y - rp.y)
}
func += (var lp:CGPoint, rp:CGPoint) -> CGPoint
{
    lp.x += rp.x
    lp.y += rp.y
    return lp
}
func -= (var lp:CGPoint, rp:CGPoint) -> CGPoint
{
    lp.x -= rp.x
    lp.y -= rp.y
    return lp
}
func * ( lp:CGPoint, mult:CGFloat) -> CGPoint
{
    return CGPoint(x: lp.x * mult, y: lp.y * mult)
}
func *= (var lp:CGPoint, mult:CGFloat) -> CGPoint
{
    lp.x *= mult
    lp.y *= mult
    return lp
}