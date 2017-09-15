//
//  Extensions.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit


func delay(delay:Double, completion:()-> Void)
{
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)));
    dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
        completion()
    }
}

extension NSDate {
    func toSinceTime() -> String{
        let dateFormatter = NSDateFormatter()
        return  dateFormatter.timeSince(self, numericDates: true)
    }
    func dayOfTheWeek() -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(self)
    }
}

extension NSDateFormatter {
    /**
    Formats a date as the time since that date (e.g., “Last week, yesterday, etc.”).
    
    - Parameter from: The date to process.
    - Parameter numericDates: Determines if we should return a numeric variant, e.g. "1 month ago" vs. "Last month".
    
    - Returns: A string with formatted `date`.
    */
    
    func timeSince(from: NSDate, numericDates: Bool = false) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(from as NSDate)
        let latest = earliest == now as NSDate ? from : now
        
        let flags:NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second]
        let components = calendar.components(flags, fromDate: earliest, toDate: latest as NSDate, options: [])
        
        var result = ""
        
        if components.year >= 2 {
            result = "\(components.year) years ago"
        } else if components.year >= 1 {
            if numericDates {
                result = "1 year ago"
            } else {
                result = "Last year"
            }
        } else if components.month >= 2 {
            result = "\(components.month) months ago"
        } else if components.month >= 1 {
            if numericDates {
                result = "1 month ago"
            } else {
                result = "Last month"
            }
        } else if components.weekOfYear >= 2 {
            result = "\(components.weekOfYear) weeks ago"
        } else if components.weekOfYear >= 1 {
            if numericDates {
                result = "1 week ago"
            } else {
                result = "Last week"
            }
        } else if components.day >= 2 {
            result = "\(components.day) days ago"
        } else if components.day >= 1 {
            if numericDates {
                result = "1 day ago"
            } else {
                result = "Yesterday"
            }
        } else if components.hour >= 2 {
            result = "\(components.hour) hours ago"
        } else if components.hour >= 1 {
            if numericDates {
                result = "1 hour ago"
            } else {
                result = "An hour ago"
            }
        } else if components.minute >= 2 {
            result = "\(components.minute) minutes ago"
        } else if components.minute >= 1 {
            if numericDates {
                result = "1 minute ago"
            } else {
                result = "A minute ago"
            }
        } else if components.second >= 3 {
            result = "\(components.second) seconds ago"
        } else {
            result = "Just now"
        }
        
        return result
    }
}


extension String{
    private mutating func toCapitalized(){
        let first = String(self.characters.first!).uppercaseString
        let other = String(self.characters.dropFirst())
        self = first + other
        
    }
    var capitalizedString:String{
        mutating get {
            if (self.characters.first?.isUppercase == false) {
                toCapitalized()
            }
            return self
        }
    }
}
extension Character {
    var isUppercase: Bool {
        let cs = String(self)
        return (cs == cs.uppercaseString) && (cs != cs.lowercaseString)
    }
}




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
    /*
    from https://stackoverflow.com/questions/7490660/converting-wind-direction-in-angles-to-text-words
    function degToCompass(num) {
    var val = Math.floor((num / 22.5) + 0.5);
    var arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
    return arr[(val % 16)];
    }
    */
    func toEarthDirection() -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        
        let direction = floor((self / 22.5) + 0.5)
        let index = Int(direction % 16)
        return directions[index]
        
    }
}
extension UIView {
    func getConstraint(with name:String) -> NSLayoutConstraint?
    {
        var constraint:NSLayoutConstraint?
        if self.constraints.count > 0 {
            for c in self.constraints {
                if (c.identifier?.containsString(name) != nil){
                    constraint = c
                    break
                }
            }
        }
        return constraint
    }
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